import 'dart:collection' show MapBase;
import 'dart:io' show HttpClientRequest;

import 'package:collection/collection.dart' show DeepCollectionEquality;

import 'http/cookies.dart' show BaseCookie;
import 'http/http.dart' show Response, Session;

class XCSRFTokenSession extends Session {
  @override
  Future<Response> request(HttpClientRequest request,
      {Object? params,
      Object? data,
      Object? json,
      BaseCookie? cookies,
      Map<String, String>? headers,
      bool followRedirects = true,
      int maxRedirects = 5}) {
    if (const ['POST', 'PUT', 'DELETE']
        .contains(request.method.toUpperCase())) {
      var tmpCookies = this.cookieJar.filterCookies(request.uri);
      if (tmpCookies.containsKey('_csrf_token')) {
        headers = headers ?? {};
        headers['X-CSRF-Token'] =
            Uri.decodeComponent(tmpCookies['_csrf_token']!.value);
      }
    }
    return super.request(request,
        data: data,
        json: json,
        cookies: cookies,
        headers: headers,
        followRedirects: followRedirects,
        maxRedirects: maxRedirects);
  }
}

class Sentinel {
  factory Sentinel() => sentinel;

  const Sentinel._sentinel();

  String toString() => "sentinel";
}

const sentinel = Sentinel._sentinel();

class Simple extends MapBase {
  late Map<String, dynamic> attirbutes;

  final List<String> toStringNames = const [];

  Simple({Map<String, dynamic>? attributes}) {
    this.attirbutes = attributes ?? {};
  }

  @override
  bool operator ==(Object other) =>
      other is Simple &&
      const DeepCollectionEquality().equals(attirbutes, other.attirbutes);

  @override
  int get hashCode => super.hashCode;

  @override
  String toString() {
    if (toStringNames.isNotEmpty) {
      var info = [];
      toStringNames.forEach((key) {
        if (attirbutes.containsKey(key)) {
          info.add('$key=${Error.safeToString(attirbutes[key])}');
        }
      });
      if (info.isNotEmpty) {
        return '${this.runtimeType}(${info.join(", ")})';
      }
    }
    return Error.safeToString(this);
  }

  @override
  operator [](Object? key) => attirbutes[key];

  @override
  void operator []=(key, value) => attirbutes[key] = value;

  @override
  void clear() => attirbutes.clear();

  @override
  Iterable get keys => attirbutes.keys;

  @override
  remove(Object? key) => attirbutes.remove(key);

  Object? getattr(String name) {
    if (attirbutes.containsKey(name)) {
      return attirbutes[name];
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
