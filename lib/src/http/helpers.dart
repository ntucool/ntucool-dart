import 'dart:convert' show Encoding, latin1, utf8;
import 'dart:io' show HttpHeaders, InternetAddress, InternetAddressType;

import 'package:http_parser/http_parser.dart' show MediaType;

import '../rfc/rfc2616.dart' show token;

/// Sets ``Content-Disposition`` header.
///
/// [disptype] is a disposition type: inline, attachment, form-data.
/// Should be valid extension token (see RFC 2183)
///
/// [params] is a map with disposition params.
String contentDispositionHeader(String disptype,
    {bool quoteFields = true, Map<String, String>? params}) {
  var match = token.matchAsPrefix(disptype);
  if (match == null || match.end != disptype.length) {
    throw ArgumentError.value(
        disptype, 'distype', 'Bad content disposition type.');
  }

  var value = disptype;
  if (params != null) {
    var lparams = <List<String>>[];
    params.forEach((key, val) {
      var match = token.matchAsPrefix(disptype);
      if (match == null || match.end != disptype.length) {
        throw ArgumentError(
            'Bad content disposition parameter ${Error.safeToString(key)}=${Error.safeToString(key)}');
      }
      var qval = quoteFields ? Uri.encodeComponent(val) : val;
      lparams.add([key, '"$qval"']);
      if (key == "filename") {
        lparams.add(["filename*", "utf-8''" + qval]);
      }
      var sparams = lparams.map((e) => e.join("=")).join("; ");
      value = [value, sparams].join("; ");
    });
  }
  return value;
}

bool isIPAddress(String? host) {
  if (host == null) {
    return false;
  }
  try {
    var internetAddress = InternetAddress(host);
    return internetAddress.type == InternetAddressType.IPv4 ||
        internetAddress.type == InternetAddressType.IPv6;
  } on ArgumentError {
    return false;
  }
}

/// Return current time rounded up to the next whole second.
DateTime nextWholeSecond() {
  var now = DateTime.now().toUtc();
  return DateTime.utc(
      now.year, now.month, now.day, now.hour, now.minute, now.second);
}

/// Returns the [Encoding] that corresponds to [charset].
///
/// Returns [fallback] if [charset] is null or if no [Encoding] was found that
/// corresponds to [charset].
Encoding encodingForCharset(String? charset, [Encoding fallback = latin1]) {
  if (charset == null) return fallback;
  return Encoding.getByName(charset) ?? fallback;
}

/// Returns the encoding to use for a response with the given headers.
///
/// Defaults to [latin1] if the headers don't specify a charset or if that
/// charset is unknown.
Encoding encodingForHeaders(HttpHeaders headers) =>
    encodingForCharset(contentTypeForHeaders(headers).parameters['charset']);

/// Returns the [MediaType] object for the given [headers]'s content-type.
///
/// Defaults to `application/octet-stream`.
MediaType contentTypeForHeaders(HttpHeaders headers) {
  var values = headers[HttpHeaders.contentTypeHeader];
  if (values != null && values.isNotEmpty) return MediaType.parse(values[0]);
  return MediaType('application', 'octet-stream');
}

/// Converts a [Map] from parameter names to values to a URL query string.
///
///     mapToQuery({"foo": "bar", "baz": "bang"});
///     //=> "foo=bar&baz=bang"
String mapToQuery(Map<String, Object> map, {Encoding? encoding}) {
  var pairs = <List<String>>[];
  map.forEach((key, value) {
    if (value is Iterable<String>) {
      for (var v in value) {
        pairs.add([
          Uri.encodeQueryComponent(key, encoding: encoding ?? utf8),
          Uri.encodeQueryComponent(v, encoding: encoding ?? utf8)
        ]);
      }
    } else if (value is String) {
      pairs.add([
        Uri.encodeQueryComponent(key, encoding: encoding ?? utf8),
        Uri.encodeQueryComponent(value, encoding: encoding ?? utf8)
      ]);
    } else {
      throw ArgumentError.value(map, 'map');
    }
  });
  return pairs.map((pair) => '${pair[0]}=${pair[1]}').join('&');
}
