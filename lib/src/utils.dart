import 'dart:convert' show jsonDecode;

import 'package:html/dom.dart' show Document;
import 'package:tuple/tuple.dart' show Tuple2, Tuple3;

import 'exceptions.dart'
    show ApiException, HttpException, JsonDecodeException, RuntimeException;
import 'http/http.dart' show Response, Session;
import 'objects.dart' show sentinel;

void addParameterBySelectors(Document document,
    Map<String, dynamic> queryParameters, Map<String, Object?> selectors) {
  selectors.forEach((selector, value) {
    var element = document.querySelector(selector);
    if (element == null) {
      throw RuntimeException();
    }
    var attributes = element.attributes;
    var name = attributes['name'];
    if (name == null) {
      throw RuntimeException();
    }
    if (value == null) {
      value = attributes['value'];
      if (value == null) {
        throw RuntimeException();
      }
    }
    queryParameters[name] = value;
  });
}

HttpException? checkStatus(Response response, {bool throwForStatus = true}) {
  HttpException? exception;
  if (400 <= response.statusCode) {
    exception = HttpException(response: response);
    if (throwForStatus) {
      throw exception;
    }
  }
  return exception;
}

Future<Tuple2<Response, ApiException?>> request(
  Session session,
  String method,
  Uri base, {
  String? reference,
  List<Object?>? paramsList,
  Object? data,
  Object? json,
  Object? cookies,
  Object? headers,
  bool throwForStatus = true,
}) async {
  var url = base;
  if (reference != null) {
    url = url.resolve(reference);
  }

  var params;

  if (method == 'GET') {
  } else if (method == 'POST' || method == 'PUT') {
  } else if (method == 'DELETE') {}

  var response = await session.openUrl(
    method,
    url,
    params: params,
    data: data,
    json: json,
    // cookies: cookies,
    // headers: headers,
  );
  var exception = checkStatus(response, throwForStatus: throwForStatus);

  return Tuple2(response, exception);
}

Future<Tuple2<dynamic, ApiException?>> getJsonFromResponse(
    Response response, ApiException? exception,
    {bool throwException = true}) async {
  var text = await response.text();
  if (text.startsWith('while(1);')) {
    text = text.substring('while(1);'.length);
  }
  var ok = false;
  dynamic data = sentinel;
  try {
    data = jsonDecode(text);
    ok = true;
  } on FormatException catch (e) {
    exception = exception ?? JsonDecodeException(e);
  }
  if (exception != null) {
    if (ok) {
      String message = '';
      var tmp = exception.message;
      if (tmp != null) {
        message = tmp.toString();
      }
      if (message.isNotEmpty) {
        message += '\n';
      }
      message += 'data: $data';
      exception.message = message;
      if (throwException) {
        throw exception;
      }
    }
  }
  return Tuple2(data, exception);
}

Future<Tuple3<dynamic, Response, ApiException?>> requestJson(
  Session session,
  String method,
  Uri base, {
  String? reference,
  List<Object?>? paramsList,
  Object? data,
  Object? json,
  Object? cookies,
  Object? headers,
  bool throwException = true,
}) async {
  var tmp = await request(
    session,
    method,
    base,
    reference: reference,
    paramsList: paramsList,
    data: data,
    json: json,
    cookies: cookies,
    headers: headers,
    throwForStatus: false,
  );
  var response = tmp.item1;
  var exception = tmp.item2;
  var tmp2 = await getJsonFromResponse(response, exception,
      throwException: throwException);
  var value = tmp2.item1;
  exception = tmp2.item2;
  return Tuple3(value, response, exception);
}

String safeToString(Object? object) {
  if (object is num || object is bool || null == object) {
    return object.toString();
  }
  if (object is String) {
    return Error.safeToString(object);
  }
  if (object is List) {
    return "${object.runtimeType}([${object.map((e) => safeToString(e)).join(', ')}])";
  }
  if (object is Set) {
    return "${object.runtimeType}({${object.map((e) => safeToString(e)).join(', ')}})";
  }
  // if (object is Map) {
  //   var info = <String>[];
  //   object.forEach((key, value) {
  //     info.add('${safeToString(key)}: ${safeToString(value)}');
  //   });
  //   return "${object.runtimeType}({${info.join(', ')}})";
  // }
  // if (object is Iterable) {
  //   return "${object.runtimeType}([${object.map((e) => safeToString(e)).join(', ')}])";
  // }
  try {
    return object.toString();
  } catch (_) {
    return Error.safeToString(object);
  }
}
