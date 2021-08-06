import 'dart:collection' show MapBase;
import 'dart:io' show Cookie;

class Morsel implements Cookie {
  late final Cookie _inner;

  Morsel.fromJson(Map<String, dynamic> json) {
    _inner = Cookie(json['name'], json['value']);
    domain = json['domain'];
    expires = json['expires'] == null
        ? json['expires']
        : DateTime.parse(json['expires']);
    httpOnly = json['httpOnly'];
    maxAge = json['maxAge'];
    path = json['path'];
    secure = json['secure'];
  }

  Map<String, dynamic> toJson() => {
        'domain': domain,
        'expires': expires?.toIso8601String(),
        'httpOnly': httpOnly,
        'maxAge': maxAge,
        'name': name,
        'path': path,
        'secure': secure,
        'value': value,
      };

  Morsel.fromCookie(Cookie cookie) {
    _inner = cookie;
  }

  Morsel(String name, String value) {
    _inner = Cookie(name, value);
  }

  Morsel.fromSetCookieValue(String value) {
    _inner = Cookie.fromSetCookieValue(value);
  }

  @override
  String? get domain => _inner.domain;
  @override
  set domain(String? _domain) => _inner.domain = _domain;

  @override
  DateTime? get expires => _inner.expires;
  @override
  set expires(DateTime? _expires) => _inner.expires = _expires;

  @override
  bool get httpOnly => _inner.httpOnly;
  @override
  set httpOnly(bool _httpOnly) => _inner.httpOnly = _httpOnly;

  @override
  int? get maxAge => _inner.maxAge;
  @override
  set maxAge(int? _maxAge) => _inner.maxAge = _maxAge;

  @override
  String get name => _inner.name;
  @override
  set name(String _name) => _inner.name = _name;

  @override
  String? get path => _inner.path;
  @override
  set path(String? _path) => _inner.path = _path;

  @override
  bool get secure => _inner.secure;
  @override
  set secure(bool _secure) => _inner.secure = _secure;

  @override
  String get value => _inner.value;
  @override
  set value(String _value) => _inner.value = _value;

  @override
  String toString() {
    return _inner.toString();
  }
}

class BaseCookie extends MapBase<String, Morsel> {
  final _inner = <String, Morsel>{};

  BaseCookie.fromJson(Map<String, dynamic> json) {
    json.forEach((key, value) {
      _inner[key] = Morsel.fromJson(value);
    });
  }

  BaseCookie();

  @override
  Morsel? operator [](Object? key) => _inner[key];

  @override
  void operator []=(String key, Morsel value) => _inner[key] = value;

  @override
  void clear() => _inner.clear();

  @override
  Iterable<String> get keys => _inner.keys;

  @override
  Morsel? remove(Object? key) => _inner.remove(key);
}

class SimpleCookie extends BaseCookie {
  SimpleCookie.fromJson(Map<String, dynamic> json) {
    json.forEach((key, value) {
      _inner[key] = Morsel.fromJson(value);
    });
  }

  SimpleCookie();
}
