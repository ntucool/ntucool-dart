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

  List<Tuple2<String, String>>? params;
  if (paramsList == null) {
    params = null;
  } else {
    params = mergeParams(paramsList);
  }

  if (method == 'GET') {
  } else if (method == 'POST' || method == 'PUT') {
    // For POST and PUT requests, parameters are sent using standard HTML form
    // encoding (the application/x-www-form-urlencoded content type).
    //
    // POST and PUT requests may also optionally be sent in JSON format format.
    // The content-type of the request must be set to application/json in this
    // case. There is currently no way to upload a file as part of a JSON POST,
    // the multipart form type must be used.
    //
    // https://canvas.instructure.com/doc/api/index.html
    if (params != null) {
      data = params;
      params = null;
    }

    // TODO: Add X-CSRF-Token to header.
  } else if (method == 'DELETE') {
    // TODO: Add X-CSRF-Token to header.
  }

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
  dynamic data = sentinel;
  try {
    data = jsonDecode(text);
  } on FormatException catch (e) {
    exception = exception ?? JsonDecodeException(e);
  }
  if (exception != null) {
    if (data != sentinel) {
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
    }
    if (throwException) {
      return Future.error(exception);
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

List<Tuple2<String, String>> resolveParams(Object? params,
    {bool brackets = false}) {
  var resolved = <Tuple2<String, String>>[];
  if (params is Map) {
    params.forEach((n, v) {
      var name = n.toString();
      if (brackets) {
        name = '[$name]';
      }
      var value = resolveParams(v, brackets: true);
      for (var tmp in value) {
        resolved.add(Tuple2(name + tmp.item1, tmp.item2));
      }
    });
  } else if (params is Iterable) {
    for (var v in params) {
      if (v is Tuple2) {
        v = [v.item1, v.item2];
      }
      String name;
      List<Tuple2<String, String>> value;
      if (v is! Map && v is Iterable) {
        if (v.length != 2) {
          throw ArgumentError.value(v);
        }
        name = v.first.toString();
        if (brackets) {
          name = '[$name]';
        }
        value = resolveParams(v.last, brackets: true);
      } else {
        name = brackets ? '[]' : '';
        value = resolveParams(v, brackets: true);
      }
      for (var tmp in value) {
        resolved.add(Tuple2(name + tmp.item1, tmp.item2));
      }
    }
  } else if (params == null) {
  } else {
    if (params is DateTime) {
      // With either encoding, all timestamps are sent and returned in ISO 8601
      // format (UTC time zone):
      //
      // YYYY-MM-DDTHH:MM:SSZ
      //
      // https://canvas.instructure.com/doc/api/index.html
      params = params.toUtc().toIso8601String();
    }
    resolved.add(Tuple2('', params.toString()));
  }
  return resolved;
}

List<Tuple2<String, String>> mergeParams(Iterable args) {
  var p = <Tuple2<String, String>>[];
  for (var element in args) {
    var params = resolveParams(element);
    p.addAll(params);
  }
  return p;
}
