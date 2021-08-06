import 'dart:async'
    show
        EventSink,
        Future,
        FutureOr,
        Stream,
        StreamConsumer,
        StreamSubscription,
        StreamTransformer;
import 'dart:convert' show Encoding, jsonDecode;
import 'dart:io'
    show
        ContentType,
        Cookie,
        HttpClient,
        HttpClientCredentials,
        HttpClientRequest,
        HttpClientResponse,
        HttpClientResponseCompressionState,
        HttpConnectionInfo,
        HttpException,
        HttpHeaders,
        HttpStatus,
        RedirectException,
        RedirectInfo,
        Socket,
        X509Certificate;
import 'dart:typed_data' show Uint8List;

import 'package:http/http.dart' show ByteStream;
import 'package:quiver/collection.dart' show Multimap;

import 'cookiejar.dart' show CookieJar;
import 'cookies.dart' show BaseCookie, Morsel, SimpleCookie;
import 'fetch_spec.dart' show isRedirectStatus;
import 'formdata.dart';
import 'helpers.dart' show encodingForHeaders;
import 'payload.dart' show BytesPayload, JsonPayload, Payload, StringPayload;

class _RedirectInfo implements RedirectInfo {
  final int statusCode;
  final String method;
  final Uri location;
  const _RedirectInfo(this.statusCode, this.method, this.location);
}

class Request implements HttpClientRequest {
  late final Session session;
  late final HttpClientRequest _inner;

  Request(this.session, this._inner);

  @override
  bool get bufferOutput => _inner.bufferOutput;
  @override
  set bufferOutput(bool _bufferOutput) => _inner.bufferOutput = _bufferOutput;

  @override
  int get contentLength => _inner.contentLength;
  @override
  set contentLength(int _contentLength) =>
      _inner.contentLength = _contentLength;

  @override
  Encoding get encoding => _inner.encoding;
  @override
  set encoding(Encoding _encoding) => _inner.encoding = _encoding;

  @override
  bool get followRedirects => _inner.followRedirects;
  @override
  set followRedirects(bool _followRedirects) =>
      _inner.followRedirects = _followRedirects;

  @override
  int get maxRedirects => _inner.maxRedirects;
  @override
  set maxRedirects(int _maxRedirects) => _inner.maxRedirects;

  @override
  bool get persistentConnection => _inner.persistentConnection;
  @override
  set persistentConnection(bool _persistentConnection) =>
      _inner.persistentConnection = _persistentConnection;

  @override
  void abort([Object? exception, StackTrace? stackTrace]) =>
      _inner.abort(exception, stackTrace);

  @override
  void add(List<int> data) => _inner.add(data);

  @override
  void addError(Object error, [StackTrace? stackTrace]) =>
      _inner.addError(error, stackTrace);

  @override
  Future addStream(Stream<List<int>> stream) => _inner.addStream(stream);

  @override
  Future<Response> close() async =>
      Response(session, this, await _inner.close());

  @override
  HttpConnectionInfo? get connectionInfo => _inner.connectionInfo;

  @override
  List<Cookie> get cookies => _inner.cookies;

  @override
  Future<Response> get done async => Response(session, this, await _inner.done);

  @override
  Future flush() => _inner.flush();

  @override
  HttpHeaders get headers => _inner.headers;

  @override
  String get method => _inner.method;

  @override
  Uri get uri => _inner.uri;

  @override
  void write(Object? object) => _inner.write(object);

  @override
  void writeAll(Iterable objects, [String separator = ""]) =>
      _inner.writeAll(objects, separator);

  @override
  void writeCharCode(int charCode) => _inner.writeCharCode(charCode);

  @override
  void writeln([Object? object = ""]) => _inner.writeln(object);
}

class Response implements HttpClientResponse {
  late final Session session;
  late final Request request;
  late final HttpClientResponse _inner;

  Response(this.session, this.request, this._inner);

  Uri get uri => request.uri;

  // TODO: Follow RFC 8288.
  // https://httpwg.org/specs/rfc8288.html
  Multimap<String, Multimap<String, Object>> get links {
    var linkHeader = headers['link'];
    if (linkHeader == null) {
      return Multimap<String, Multimap<String, Object>>();
    }
    var linksStr = linkHeader.join(', ');

    var links = Multimap<String, Multimap<String, Object>>();

    var vals = <String>[];
    var start = 0;
    for (var match in RegExp(r",(?=\s*<)").allMatches(linksStr)) {
      vals.add(linksStr.substring(start, match.start));
      start = match.end;
    }
    vals.add(linksStr.substring(start));

    for (var val in vals) {
      var match = RegExp(r"\s*<(.*)>(.*)").matchAsPrefix(val);
      if (match == null) {
        continue;
      }
      var url = match.group(1)!;
      var paramsStr = match.group(2)!;
      var params = paramsStr.split(";").sublist(1);

      var link = Multimap<String, Object>();

      for (var param in params) {
        match = RegExp('^\\s*(\\S*)\\s*=\\s*([\'\\"]?)(.*?)(\\2)\\s*\$',
                multiLine: true)
            .matchAsPrefix(param);
        if (match == null) {
          continue;
        }
        var key = match.group(1)!;
        var value = match.group(3)!;

        link.add(key, value);
      }

      var key = link.containsKey('rel') ? link['rel'].first as String : url;

      link.add('url', uri.resolve(url));

      links.add(key, link);
    }

    return links;
  }

  Uint8List? _body;

  Future<Uint8List> read() async {
    if (_body == null) {
      var stream = (handleError(
        (error) {
          HttpException;
          // final httpException = error as HttpException;
          // throw ClientException(httpException.message, httpException.uri);
          throw error;
        },
        // test: (error) => error is HttpException,
      ));
      _body = await ByteStream(stream).toBytes();
    }
    return _body!;
  }

  Future<String> text() async {
    if (_body == null) {
      await read();
    }
    return encodingForHeaders(headers).decode(_body!);
  }

  Future<dynamic> json() async {
    return jsonDecode(await text());
  }

  @override
  Future<bool> any(bool Function(List<int> element) test) => _inner.any(test);

  @override
  Stream<List<int>> asBroadcastStream(
          {void Function(StreamSubscription<List<int>> subscription)? onListen,
          void Function(StreamSubscription<List<int>> subscription)?
              onCancel}) =>
      _inner.asBroadcastStream(onListen: onListen, onCancel: onCancel);

  @override
  Stream<E> asyncExpand<E>(Stream<E>? Function(List<int> event) convert) =>
      _inner.asyncExpand<E>(convert);

  @override
  Stream<E> asyncMap<E>(FutureOr<E> Function(List<int> event) convert) =>
      _inner.asyncMap<E>(convert);

  @override
  Stream<R> cast<R>() => _inner.cast<R>();

  @override
  X509Certificate? get certificate => _inner.certificate;

  @override
  HttpClientResponseCompressionState get compressionState =>
      _inner.compressionState;

  @override
  HttpConnectionInfo? get connectionInfo => _inner.connectionInfo;

  @override
  Future<bool> contains(Object? needle) => _inner.contains(needle);

  @override
  int get contentLength => _inner.contentLength;

  @override
  List<Cookie> get cookies => _inner.cookies;

  @override
  Future<Socket> detachSocket() => _inner.detachSocket();

  @override
  Stream<List<int>> distinct(
          [bool Function(List<int> previous, List<int> next)? equals]) =>
      _inner.distinct(equals);

  @override
  Future<E> drain<E>([E? futureValue]) => _inner.drain<E>(futureValue);

  @override
  Future<List<int>> elementAt(int index) => _inner.elementAt(index);

  @override
  Future<bool> every(bool Function(List<int> element) test) =>
      _inner.every(test);

  @override
  Stream<S> expand<S>(Iterable<S> Function(List<int> element) convert) =>
      _inner.expand<S>(convert);

  @override
  Future<List<int>> get first => _inner.first;

  @override
  Future<List<int>> firstWhere(bool Function(List<int> element) test,
          {List<int> Function()? orElse}) =>
      _inner.firstWhere(test, orElse: orElse);

  @override
  Future<S> fold<S>(
          S initialValue, S Function(S previous, List<int> element) combine) =>
      _inner.fold<S>(initialValue, combine);

  @override
  Future forEach(void Function(List<int> element) action) =>
      _inner.forEach(action);

  @override
  Stream<List<int>> handleError(Function onError,
          {bool Function(dynamic)? test}) =>
      _inner.handleError(onError, test: test);

  @override
  HttpHeaders get headers => _inner.headers;

  @override
  bool get isBroadcast => _inner.isBroadcast;

  @override
  Future<bool> get isEmpty => _inner.isEmpty;

  @override
  bool get isRedirect {
    // TODO: follow Fetch Standard, Chromium, or RFC 7231?
    // https://fetch.spec.whatwg.org/
    // HttpResponseHeaders::IsRedirect
    // https://source.chromium.org/chromium/chromium/src/+/main:net/http/http_response_headers.cc
    // RedirectInfo::ComputeRedirectInfo
    // https://source.chromium.org/chromium/chromium/src/+/main:net/url_request/redirect_info.cc;drc=acf367004aa6c15006bf09839c82b7ffa9f4fb9b;bpv=1;bpt=1;l=116?gsn=ComputeRedirectInfo&gs=kythe%3A%2F%2Fchromium.googlesource.com%2Fchromium%2Fsrc%3Flang%3Dc%252B%252B%3Fpath%3Dsrc%2Fnet%2Furl_request%2Fredirect_info.h%23_kNwy3vXazt1ze7Q9mu_W6T31eXfC-gKoJcUIl06gVY&gs=kythe%3A%2F%2Fchromium.googlesource.com%2Fchromium%2Fsrc%3Flang%3Dc%252B%252B%3Fpath%3Dsrc%2Fnet%2Furl_request%2Fredirect_info.cc%23Zxaj6lB8foAMTRjckZ57YitXpLM7B4B9Ab3RqAobkNM
    // https://httpwg.org/specs/rfc7231.html

    // https://wiki.whatwg.org/wiki/HTTP

    return isRedirectStatus(statusCode);

    // dart's implementation follows RFC 2616
    // https://github.com/dart-lang/sdk/commit/254eae71a1d82b343dc46b17ab3f8d2626f3f292
    // https://github.com/dart-lang/sdk/issues/38413
    return _inner.isRedirect;
  }

  @override
  Future<String> join([String separator = ""]) => _inner.join(separator);

  @override
  Future<List<int>> get last => _inner.last;

  @override
  Future<List<int>> lastWhere(bool Function(List<int> element) test,
          {List<int> Function()? orElse}) =>
      _inner.lastWhere(test, orElse: orElse);

  @override
  Future<int> get length => _inner.length;

  @override
  StreamSubscription<List<int>> listen(void Function(List<int> event)? onData,
          {Function? onError, void Function()? onDone, bool? cancelOnError}) =>
      _inner.listen(onData,
          onError: onError, onDone: onDone, cancelOnError: cancelOnError);

  @override
  Stream<S> map<S>(S Function(List<int> event) convert) =>
      _inner.map<S>(convert);

  @override
  bool get persistentConnection => _inner.persistentConnection;

  @override
  Future pipe(StreamConsumer<List<int>> streamConsumer) =>
      _inner.pipe(streamConsumer);

  @override
  String get reasonPhrase => _inner.reasonPhrase;

  // TODO: follow Fetch Standard, Chromium, or RFC 7231?
  @override
  Future<HttpClientResponse> redirect(
          [String? method, Uri? url, bool? followLoops]) =>
      _inner.redirect(method, url, followLoops);

  @override
  List<RedirectInfo> get redirects => _inner.redirects;

  @override
  Future<List<int>> reduce(
          List<int> Function(List<int> previous, List<int> element) combine) =>
      _inner.reduce(combine);

  @override
  Future<List<int>> get single => _inner.single;

  @override
  Future<List<int>> singleWhere(bool Function(List<int> element) test,
          {List<int> Function()? orElse}) =>
      _inner.singleWhere(test, orElse: orElse);

  @override
  Stream<List<int>> skip(int count) => _inner.skip(count);

  @override
  Stream<List<int>> skipWhile(bool Function(List<int> element) test) =>
      _inner.skipWhile(test);

  @override
  int get statusCode => _inner.statusCode;

  @override
  Stream<List<int>> take(int count) => _inner.take(count);

  @override
  Stream<List<int>> takeWhile(bool Function(List<int> element) test) =>
      _inner.takeWhile(test);

  @override
  Stream<List<int>> timeout(Duration timeLimit,
          {void Function(EventSink<List<int>> sink)? onTimeout}) =>
      _inner.timeout(timeLimit, onTimeout: onTimeout);

  @override
  Future<List<List<int>>> toList() => _inner.toList();

  @override
  Future<Set<List<int>>> toSet() => _inner.toSet();

  @override
  Stream<S> transform<S>(StreamTransformer<List<int>, S> streamTransformer) =>
      _inner.transform(streamTransformer);

  @override
  Stream<List<int>> where(bool Function(List<int> event) test) =>
      _inner.where(test);
}

class Session {
  final client = HttpClient();

  late CookieJar cookieJar;

  Session({CookieJar? cookieJar}) {
    this.cookieJar = cookieJar ?? CookieJar();
  }

  bool get autoUncompress => client.autoUncompress;
  set autoUncompress(bool _autoUncompress) =>
      client.autoUncompress = _autoUncompress;

  Duration? get connectionTimeout => client.connectionTimeout;
  set connectionTimeout(Duration? _connectionTimeout) =>
      client.connectionTimeout = _connectionTimeout;

  Duration get idleTimeout => client.idleTimeout;
  set idleTimeout(Duration _idleTimeout) => client.idleTimeout = _idleTimeout;

  int? get maxConnectionsPerHost => client.maxConnectionsPerHost;
  set maxConnectionsPerHost(int? _maxConnectionsPerHost) =>
      client.maxConnectionsPerHost = _maxConnectionsPerHost;

  String? get userAgent => client.userAgent;
  set userAgent(String? _userAgent) => client.userAgent = _userAgent;

  void addCredentials(
          Uri url, String realm, HttpClientCredentials credentials) =>
      client.addCredentials(url, realm, credentials);

  void addProxyCredentials(String host, int port, String realm,
          HttpClientCredentials credentials) =>
      client.addProxyCredentials(host, port, realm, credentials);

  set authenticate(
          Future<bool> Function(Uri url, String scheme, String realm)? f) =>
      client.authenticate = f;

  set authenticateProxy(
          Future<bool> Function(
                  String host, int port, String scheme, String realm)?
              f) =>
      client.authenticateProxy = f;

  set badCertificateCallback(
          bool Function(X509Certificate cert, String host, int port)?
              callback) =>
      client.badCertificateCallback = callback;

  void close({bool force = false}) => client.close(force: force);

  Future<Response> request(HttpClientRequest inner,
      {Object? params,
      Object? data,
      Object? json,
      BaseCookie? cookies,
      Map<String, String>? headers,
      bool followRedirects = true,
      int maxRedirects = 5}) async {
    var request = Request(this, inner);

    // print(['cookieJar', cookieJar]);

    if (data != null && json != null) {
      throw ArgumentError(
          "data and json parameters can not be used at the same time");
    } else if (json != null) {
      data = JsonPayload(json);
    }

    _updateHeaders(request.headers, headers);

    var allCookies = _getAllCookies(cookieJar, request, cookies);
    request.headers.removeAll(HttpHeaders.cookieHeader);
    request.cookies.clear();
    request.cookies.addAll(allCookies.values);

    request.followRedirects = false;

    // if (data != null) {
    //   request.headers.contentType =
    //       ContentType('application', 'x-www-form-urlencoded');
    //   request.write(data);
    // }
    var payload = _updateBodyFromData(data);
    payload?.write(request);

    var response = await request.close();
    // print(request.headers);
    print(response.redirects.length);
    _updateCookiesFromResponse(cookieJar, response, request.uri);
    // print(['cookieJar', cookieJar]);

    while (followRedirects && response.isRedirect) {
      if (response.redirects.length < maxRedirects) {
        // Redirect and drain response.
        await response.drain();
        response =
            await _redirect(this, request, response, onRequest: (request) {
          var allCookies = _getAllCookies(cookieJar, request, cookies);
          request.headers.removeAll(HttpHeaders.cookieHeader);
          request.cookies.clear();
          request.cookies.addAll(allCookies.values);
          return request.close();
        });
        print(response.redirects.length);
        _updateCookiesFromResponse(cookieJar, response, response.request.uri);
        // print(['cookieJar', cookieJar]);
      } else {
        // End with exception, too many redirects.
        await response.drain();
        return Future<Response>.error(
            RedirectException("Redirect limit exceeded", response.redirects));
      }
    }
    return response;
  }

  Future<Response> delete(String host, int port, String path,
          {Object? data,
          Object? json,
          BaseCookie? cookies,
          Map<String, String>? headers,
          bool followRedirects = true,
          int maxRedirects = 5}) async =>
      request(await client.delete(host, port, path),
          data: data,
          json: json,
          cookies: cookies,
          headers: headers,
          followRedirects: followRedirects,
          maxRedirects: maxRedirects);

  Future<Response> deleteUrl(Uri url,
          {Object? data,
          Object? json,
          BaseCookie? cookies,
          Map<String, String>? headers,
          bool followRedirects = true,
          int maxRedirects = 5}) async =>
      request(await client.deleteUrl(url),
          data: data,
          json: json,
          cookies: cookies,
          headers: headers,
          followRedirects: followRedirects,
          maxRedirects: maxRedirects);

  set findProxy(String Function(Uri url)? f) => client.findProxy = f;

  Future<Response> get(String host, int port, String path,
          {Object? data,
          Object? json,
          BaseCookie? cookies,
          Map<String, String>? headers,
          bool followRedirects = true,
          int maxRedirects = 5}) async =>
      request(await client.get(host, port, path),
          data: data,
          json: json,
          cookies: cookies,
          headers: headers,
          followRedirects: followRedirects,
          maxRedirects: maxRedirects);

  Future<Response> getUrl(Uri url,
          {Object? data,
          Object? json,
          BaseCookie? cookies,
          Map<String, String>? headers,
          bool followRedirects = true,
          int maxRedirects = 5}) async =>
      request(await client.getUrl(url),
          data: data,
          json: json,
          cookies: cookies,
          headers: headers,
          followRedirects: followRedirects,
          maxRedirects: maxRedirects);

  Future<Response> head(String host, int port, String path) {
    // TODO: implement head
    throw UnimplementedError();
  }

  Future<Response> headUrl(Uri url) {
    // TODO: implement headUrl
    throw UnimplementedError();
  }

  Future<Response> open(String method, String host, int port, String path,
          {Object? data,
          Object? json,
          BaseCookie? cookies,
          Map<String, String>? headers,
          bool followRedirects = true,
          int maxRedirects = 5}) async =>
      request(await client.open(method, host, port, path),
          data: data,
          json: json,
          cookies: cookies,
          headers: headers,
          followRedirects: followRedirects,
          maxRedirects: maxRedirects);

  Future<Response> openUrl(String method, Uri url,
          {Object? params,
          Object? data,
          Object? json,
          BaseCookie? cookies,
          Map<String, String>? headers,
          bool followRedirects = true,
          int maxRedirects = 5}) async =>
      request(await client.openUrl(method, url),
          data: data,
          json: json,
          cookies: cookies,
          headers: headers,
          followRedirects: followRedirects,
          maxRedirects: maxRedirects);

  Future<Response> patch(String host, int port, String path) {
    // TODO: implement patch
    throw UnimplementedError();
  }

  Future<Response> patchUrl(Uri url) {
    // TODO: implement patchUrl
    throw UnimplementedError();
  }

  Future<Response> post(String host, int port, String path,
          {Object? data,
          Object? json,
          BaseCookie? cookies,
          Map<String, String>? headers,
          bool followRedirects = true,
          int maxRedirects = 5}) async =>
      request(await client.post(host, port, path),
          data: data,
          json: json,
          cookies: cookies,
          headers: headers,
          followRedirects: followRedirects,
          maxRedirects: maxRedirects);

  Future<Response> postUrl(Uri url,
          {Object? data,
          Object? json,
          BaseCookie? cookies,
          Map<String, String>? headers,
          bool followRedirects = true,
          int maxRedirects = 5}) async =>
      request(await client.postUrl(url),
          data: data,
          json: json,
          cookies: cookies,
          headers: headers,
          followRedirects: followRedirects,
          maxRedirects: maxRedirects);

  Future<Response> put(String host, int port, String path,
          {Object? data,
          Object? json,
          BaseCookie? cookies,
          Map<String, String>? headers,
          bool followRedirects = true,
          int maxRedirects = 5}) async =>
      request(await client.put(host, port, path),
          data: data,
          json: json,
          cookies: cookies,
          headers: headers,
          followRedirects: followRedirects,
          maxRedirects: maxRedirects);

  Future<Response> putUrl(Uri url,
          {Object? data,
          Object? json,
          BaseCookie? cookies,
          Map<String, String>? headers,
          bool followRedirects = true,
          int maxRedirects = 5}) async =>
      request(await client.putUrl(url),
          data: data,
          json: json,
          cookies: cookies,
          headers: headers,
          followRedirects: followRedirects,
          maxRedirects: maxRedirects);
}

Future<Response> _redirect(Session session, Request request, Response response,
    {String? method,
    Uri? url,
    bool? followLoops,
    Future<Response> onRequest(Request request)?}) async {
  // TODO: follow Fetch Standard, Chromium, or RFC 7231?
  if (onRequest == null) {
    onRequest = (request) => request.close();
  }
  if (method == null) {
    method = request.method;
    if (((response.statusCode == HttpStatus.movedPermanently ||
                response.statusCode == HttpStatus.found) &&
            method == 'POST') ||
        (response.statusCode == HttpStatus.seeOther &&
            (method != 'GET' && method != 'HEAD'))) {
      // TODO: https://fetch.spec.whatwg.org/#http-redirect-fetch
      // 4.4. HTTP-redirect fetch 13.
      // Chromium sets the new request’s body to null if the new method differs
      // from the original method
      method = 'GET';
    }
  }
  if (url == null) {
    String? location = response.headers.value(HttpHeaders.locationHeader);
    if (location == null) {
      throw StateError("Response has no Location header for redirect");
    }
    url = Uri.parse(location);
  }
  if (followLoops != true) {
    for (var redirect in response.redirects) {
      if (redirect.location == url) {
        return Future.error(
            RedirectException("Redirect loop detected", response.redirects));
      }
    }
  }

  // ignore: close_sinks
  var newRequest = await _openUrlFromRequest(session, method, url, request);

  var newResponse = await onRequest(newRequest);
  newResponse.redirects.insertAll(0,
      [...response.redirects, _RedirectInfo(response.statusCode, method, url)]);
  return newResponse;
}

Future<Request> _openUrlFromRequest(
    Session session, String method, Uri uri, Request previous) {
  // TODO: follow Fetch Standard, Chromium, or RFC 7231?

  // If the new URI is relative (to either '/' or some sub-path),
  // construct a full URI from the previous one.
  Uri resolved = previous.uri.resolveUri(uri);
  return session.client.openUrl(method, resolved).then((inner) {
    // ignore: close_sinks
    var request = Request(session, inner);
    request
      // Only follow redirects if initial request did.
      ..followRedirects = previous.followRedirects
      // Allow same number of redirects.
      ..maxRedirects = previous.maxRedirects;
    // Copy headers.
    previous.headers.forEach((header, _) {
      if (request.headers[header] == null) {
        request.headers.set(header, previous.headers[header]!);
      }
    });
    return request
      ..headers.chunkedTransferEncoding = false
      ..contentLength = 0;
  });
}

void _updateHeaders(HttpHeaders headers, Map<String, String>? newHeaders) {
  if (newHeaders == null) {
    return;
  }
  newHeaders.forEach((name, value) {
    headers.add(name, value);
  });
}

Payload? _updateBodyFromData(Object? data) {
  Payload? payload;
  if (data == null) {
    payload = null;
  } else if (data is Payload) {
    payload = data;
  } else if (data is FormData) {
    payload = data();
  } else if (data is Uint8List) {
    payload = BytesPayload(data);
  } else if (data is String) {
    payload = StringPayload(data);
  } else {
    payload = FormData(data)();
  }

  return payload;
}

SimpleCookie _getAllCookies(
    CookieJar cookieJar, HttpClientRequest request, BaseCookie? cookies) {
  var allCookies = cookieJar.filterCookies(request.uri);
  if (cookies != null) {
    var tmpCookieJar = CookieJar();
    tmpCookieJar.updateCookies(cookies);
    var reqCookies = tmpCookieJar.filterCookies(request.uri);
    if (reqCookies.isNotEmpty) {
      allCookies.addAll(reqCookies);
    }
  }
  return allCookies;
}

void _updateCookiesFromResponse(CookieJar cookieJar, Response response,
    [Uri? url]) {
  var tmpCookies = SimpleCookie();
  for (var cookie in response.cookies) {
    tmpCookies[cookie.name] = Morsel.fromCookie(cookie);
  }
  cookieJar.updateCookies(tmpCookies, url);
}
