import 'http/http.dart' show Request, Response;
import 'objects.dart' show sentinel;

class NtucoolException implements Exception {
  var message;

  NtucoolException([this.message]);

  @override
  String toString() {
    Object? message = this.message;
    if (message == null) {
      return "${this.runtimeType}";
    }
    return "${this.runtimeType}: $message";
  }
}

class RuntimeException implements NtucoolException {
  @override
  var message;

  RuntimeException([message]);

  @override
  String toString() {
    Object? message = this.message;
    if (message == null) {
      return "${this.runtimeType}";
    }
    return "${this.runtimeType}: $message";
  }
}

class ApiException implements NtucoolException {
  @override
  var message;

  ApiException([message]);

  @override
  String toString() {
    Object? message = this.message;
    if (message == null) {
      return "${this.runtimeType}";
    }
    return "${this.runtimeType}: $message";
  }
}

class HttpException implements ApiException {
  @override
  var message;

  int? statusCode;
  String? reasonPhrase;
  var data;
  Response? response;
  Request? request;

  HttpException(
      {message,
      int? statusCode,
      String? reasonPhrase,
      data = sentinel,
      Request? request,
      Response? response}) {
    if (response != null) {
      statusCode = statusCode ?? response.statusCode;
      reasonPhrase = reasonPhrase ?? response.reasonPhrase;
      request = request ?? response.request;
    }
    if (message == null) {
      if (reasonPhrase == null) {
        message = statusCode;
      } else {
        message = '$statusCode $reasonPhrase';
      }
    }
    this.message = message;
    this.statusCode = statusCode;
    this.reasonPhrase = reasonPhrase;
    this.data = data;
    this.response = response;
    this.request = request;
  }

  @override
  String toString() {
    Object? message = this.message;
    if (message == null) {
      return "${this.runtimeType}";
    }
    return "${this.runtimeType}: $message";
  }
}

class JsonDecodeException implements ApiException {
  @override
  var message;

  FormatException? formatException;

  JsonDecodeException(formatException) {
    this.formatException = formatException;
    this.message = formatException;
  }
}
