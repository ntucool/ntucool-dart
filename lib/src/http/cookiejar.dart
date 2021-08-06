import 'dart:collection' show IterableBase;

import 'package:tuple/tuple.dart' show Tuple2;

import '../collections.dart' show DefaultMap;
import 'cookies.dart' show BaseCookie, Morsel, SimpleCookie;
import 'helpers.dart' show isIPAddress, nextWholeSecond;

/// Implements cookie storage adhering to RFC 6265.
// TODO: RFC 6265
// https://httpwg.org/specs/rfc6265.html
class CookieJar extends IterableBase<Morsel> {
  static final maxTime =
      DateTime.fromMillisecondsSinceEpoch(8640000000000000, isUtc: true);

  final _cookies = DefaultMap<String, SimpleCookie>(() => SimpleCookie());
  final _hostOnlyCookies = Set<Tuple2<String, String>>();
  late final bool _unsafe;
  var _nextExpiration = nextWholeSecond();
  final _expirations = <Tuple2<String, String>, DateTime>{};
  final _maxTime = maxTime;

  CookieJar({bool unsafe = false}) {
    _unsafe = unsafe;
  }

  void clear() {
    _cookies.clear();
    _hostOnlyCookies.clear();
    _nextExpiration = nextWholeSecond();
    _expirations.clear();
  }

  void _doExpiration() {
    var now = DateTime.now().toUtc();
    if (_nextExpiration.isAfter(now)) {
      return;
    }
    if (_expirations.isEmpty) {
      return;
    }
    var nextExpiration = _maxTime;
    var toDel = <Tuple2<String, String>>[];
    var cookies = _cookies;
    var expirations = _expirations;
    expirations.forEach((key, when) {
      var domain = key.item1, name = key.item2;
      if (when.isBefore(now) || when.isAtSameMomentAs(now)) {
        cookies[domain].remove(name);
        toDel.add(Tuple2(domain, name));
        _hostOnlyCookies.remove(Tuple2(domain, name));
      } else {
        nextExpiration = nextExpiration.isBefore(when) ? nextExpiration : when;
      }
    });
    for (var key in toDel) {
      expirations.remove(key);
    }

    try {
      _nextExpiration = nextExpiration.add(Duration(seconds: 1));
    } on ArgumentError {
      _nextExpiration = _maxTime;
    }
  }

  void _expireCookie(DateTime when, String domain, String name) {
    _nextExpiration = _nextExpiration.isBefore(when) ? _nextExpiration : when;
    _expirations[Tuple2(domain, name)] = when;
  }

  /// Update cookies.
  void updateCookies(BaseCookie cookies, [Uri? responseUrl]) {
    responseUrl = responseUrl ?? Uri();

    var hostname = responseUrl.host;
    // print(['hostname', hostname]);

    if (!_unsafe && isIPAddress(hostname)) {
      // Don't accept cookies from IPs
      return;
    }

    for (var entry in cookies.entries) {
      var name = entry.key;
      var cookie = entry.value;

      var domain = cookie.domain ?? '';
      // print(['domain', domain]);

      // ignore domains with trailing dots
      if (domain.endsWith(".")) {
        domain = "";
        cookie.domain = null;
      }

      if (domain == '' && hostname != '') {
        // Set the cookie's domain to the response hostname
        // and set its host-only-flag
        _hostOnlyCookies.add(Tuple2(hostname, name));
        domain = hostname;
        cookie.domain = hostname;
      }

      if (domain.startsWith(".")) {
        // Remove leading dot
        domain = domain.substring(1);
        cookie.domain = domain;
      }

      if (hostname != '' && !_isDomainMatch(domain, hostname)) {
        // Setting cookies for different domains is not allowed
        continue;
      }

      var path = cookie.path ?? '';
      if (path == '' || !path.startsWith("/")) {
        // Set the cookie's path to the response path
        path = responseUrl.path;
        if (!path.startsWith("/")) {
          path = "/";
        } else {
          // Cut everything from the last slash to the end
          path = "/" + path.substring(1, path.lastIndexOf("/"));
        }
        cookie.path = path;
      }

      var maxAge = cookie.maxAge;
      if (maxAge != null) {
        var deltaSeconds = maxAge;
        DateTime maxAgeExpiration;
        try {
          maxAgeExpiration =
              DateTime.now().toUtc().add(Duration(seconds: deltaSeconds));
        } on ArgumentError {
          maxAgeExpiration = _maxTime;
        }
        _expireCookie(maxAgeExpiration, domain, name);
      } else {
        var expires = cookie.expires;
        if (expires != null) {
          var expireTime = expires;
          _expireCookie(expireTime, domain, name);
        }
      }

      _cookies[domain][name] = cookie;
    }

    _doExpiration();
  }

  /// Returns this jar's cookies filtered by their attributes.
  ///
  /// NOTE:
  /// The cookies returned are not the orginal cookies.
  /// Only name and value are preserved.
  SimpleCookie filterCookies([Uri? requestUrl]) {
    requestUrl = requestUrl ?? Uri();

    _doExpiration();
    var filtered = SimpleCookie();
    var hostname = requestUrl.host;
    var isNotSecure = !["https", "wss"].contains(requestUrl.scheme);

    for (var cookie in this) {
      var name = cookie.name;
      var domain = cookie.domain;

      // Send shared cookies
      if (domain == null || domain == '') {
        filtered[name] = Morsel(name, cookie.value);
        continue;
      }

      if (!_unsafe && isIPAddress(hostname)) {
        continue;
      }

      if (_hostOnlyCookies.contains(Tuple2(domain, name))) {
        if (domain != hostname) {
          continue;
        }
      } else if (!_isDomainMatch(domain, hostname)) {
        continue;
      }

      if (!_isPathMatch(requestUrl.path, cookie.path ?? '')) {
        continue;
      }

      if (isNotSecure && cookie.secure) {
        continue;
      }

      var mrslVal = Morsel(cookie.name, cookie.value);
      filtered[name] = mrslVal;
    }

    return filtered;
  }

  /// Implements domain matching adhering to RFC 6265.
  static bool _isDomainMatch(String domain, String hostname) {
    if (hostname == domain) {
      return true;
    }

    if (!hostname.endsWith(domain)) {
      return false;
    }

    var nonMatching = hostname.substring(0, hostname.length - domain.length);

    if (!nonMatching.endsWith(".")) {
      return false;
    }

    return !isIPAddress(hostname);
  }

  // Implements path matching adhering to RFC 6265.
  static bool _isPathMatch(String reqPath, String cookiePath) {
    if (!reqPath.startsWith("/")) {
      reqPath = "/";
    }

    if (reqPath == cookiePath) {
      return true;
    }

    if (!reqPath.startsWith(cookiePath)) {
      return false;
    }

    if (cookiePath.endsWith("/")) {
      return true;
    }

    var nonMatching = reqPath.substring(cookiePath.length);

    return nonMatching.startsWith("/");
  }

  @override
  Iterator<Morsel> get iterator {
    _doExpiration();
    return (() sync* {
      for (var val in _cookies.values) {
        yield* val.values;
      }
    })()
        .iterator;
  }
}
