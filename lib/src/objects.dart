import 'dart:collection' show MapBase;

import 'package:collection/collection.dart' show DeepCollectionEquality;

import 'http/cookies.dart' show BaseCookie;
import 'http/http.dart' show Response, Session;

class XCSRFTokenSession extends Session {
  @override
  Future<Response> requestUrl(
    String method,
    Uri url, {
    Object? params,
    Object? data,
    Object? json,
    BaseCookie? cookies,
    Map<String, String>? headers,
    bool followRedirects = true,
    int maxRedirects = 5,
  }) {
    if (const ['POST', 'PUT', 'DELETE'].contains(method.toUpperCase())) {
      var tmpCookies = this.cookieJar.filterCookies(url);
      if (tmpCookies.containsKey('_csrf_token')) {
        headers = headers ?? {};
        headers['X-CSRF-Token'] =
            Uri.decodeComponent(tmpCookies['_csrf_token']!.value);
      }
    }
    return super.requestUrl(
      method,
      url,
      data: data,
      json: json,
      cookies: cookies,
      headers: headers,
      followRedirects: followRedirects,
      maxRedirects: maxRedirects,
    );
  }
}

class Sentinel {
  factory Sentinel() => sentinel;

  const Sentinel._sentinel();

  String toString() => "sentinel";
}

const sentinel = Sentinel._sentinel();

class Simple extends MapBase {
  late Map<String, dynamic> attributes;

  final List<String> toStringNames = const [];

  Simple({Map<String, dynamic>? attributes}) {
    this.attributes = attributes ?? {};
  }

  @override
  bool operator ==(Object other) =>
      other is Simple &&
      const DeepCollectionEquality().equals(attributes, other.attributes);

  @override
  int get hashCode => super.hashCode;

  @override
  String toString() {
    if (toStringNames.isNotEmpty) {
      var info = [];
      toStringNames.forEach((key) {
        if (attributes.containsKey(key)) {
          info.add('$key=${Error.safeToString(attributes[key])}');
        }
      });
      if (info.isNotEmpty) {
        return '${this.runtimeType}(${info.join(", ")})';
      }
    }
    return Error.safeToString(this);
  }

  @override
  operator [](Object? key) => attributes[key];

  @override
  void operator []=(key, value) => attributes[key] = value;

  @override
  void clear() => attributes.clear();

  @override
  Iterable get keys => attributes.keys;

  @override
  remove(Object? key) => attributes.remove(key);

  Object? getattr(
    String name, {
    Object? constructor(attirbutes)?,
    bool isList = false,
  }) {
    if (attributes.containsKey(name)) {
      var value = attributes[name];
      if (constructor != null) {
        if (isList) {
          return [for (var v in value) constructor(v)];
        } else {
          return constructor(value);
        }
      }
      return value;
    }
    return sentinel;
  }
}

mixin Interface {
  Session? _session;
  Uri? _baseUrl;
  List<Interface> subInterfaces = [];

  Session? get session => _session;
  set session(Session? value) {
    _session = value;
    for (var interface in subInterfaces) {
      interface.session = value;
    }
  }

  Uri? get baseUrl => _baseUrl;
  set baseUrl(Uri? value) {
    _baseUrl = value;
    for (var interface in subInterfaces) {
      interface.baseUrl = value;
    }
  }
}

class Base extends Simple with Interface {
  Base({Map<String, dynamic>? attributes, Session? session, Uri? baseUrl})
      : super(attributes: attributes) {
    if (session != null) {
      this.session = session;
    }
    if (baseUrl != null) {
      this.baseUrl = baseUrl;
    }
  }
}
