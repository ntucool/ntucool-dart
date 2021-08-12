import 'dart:convert' show Encoding, jsonEncode, utf8;
import 'dart:io' show ContentType, HttpClientRequest, HttpHeaders;
import 'dart:typed_data' show Uint8List;

import 'package:mime/mime.dart' show lookupMimeType;
import 'package:quiver/collection.dart' show Multimap;

import '../objects.dart' show sentinel;
import 'helpers.dart' show contentDispositionHeader;

mixin Payload {
  static const _defaultContentType = "application/octet-stream";
  int? size;

  Object? value;

  /// Payload encoding
  Encoding? encoding;

  /// Filename of the payload.
  String? filename;

  /// Custom item headers
  var headers = Multimap<String, String>();

  void _init(
    value, {
    Multimap<String, String>? headers,
    Object? contentType = sentinel,
    filename,
    encoding,
  }) {
    this.encoding = encoding;
    this.filename = filename;
    this.value = value;
    if (contentType != sentinel && contentType != null) {
      if (contentType is! String) {
        throw ArgumentError.value(contentType, 'contentType');
      }
      this.headers.removeAll(HttpHeaders.contentTypeHeader);
      this.headers.add(HttpHeaders.contentTypeHeader, contentType);
    } else if (filename != null) {
      contentType = lookupMimeType(filename);
      if (contentType == null) {
        contentType = _defaultContentType;
      }
      this.headers.removeAll(HttpHeaders.contentTypeHeader);
      this.headers.add(HttpHeaders.contentTypeHeader, contentType as String);
    } else {
      this.headers.removeAll(HttpHeaders.contentTypeHeader);
      this.headers.add(HttpHeaders.contentTypeHeader, _defaultContentType);
    }
    if (headers != null) {
      this.headers.addAll(headers);
    }
  }

  /// Content type
  String get contentType => headers[HttpHeaders.contentTypeHeader].first;

  void setContentDisposition(String disptype,
      {bool quoteFields = true, Map<String, String>? params}) {
    headers.removeAll("Content-Disposition");
    headers.add(
        "Content-Disposition",
        contentDispositionHeader(disptype,
            quoteFields: quoteFields, params: params));
  }

  void write(HttpClientRequest request) {
    request.write(value);
  }
}

class BytesPayload with Payload {
  covariant late Uint8List value;

  BytesPayload(
    Uint8List value, {
    Multimap<String, String>? headers,
    String? contentType = "application/octet-stream",
    String? filename,
    Encoding? encoding,
  }) {
    _init(value,
        headers: headers,
        contentType: contentType,
        filename: filename,
        encoding: encoding);

    size = value.length;
  }

  @override
  void write(HttpClientRequest request) {
    var contentType = ContentType.parse(this.contentType);
    request.headers.contentType = ContentType(
        contentType.primaryType, contentType.subType,
        charset: contentType.charset ?? encoding?.name);
    request.add(value);
  }
}

class StringPayload with Payload {
  StringPayload(
    String value, {
    Encoding? encoding,
    String? contentType,
    Multimap<String, String>? headers,
    String? filename,
  }) {
    Encoding realEncoding;
    if (encoding == null) {
      if (contentType == null) {
        realEncoding = utf8;
        contentType = "text/plain; charset=utf-8";
      } else {
        var mimetype = ContentType.parse(contentType);
        var charset = mimetype.charset;
        if (charset == null) {
          realEncoding = utf8;
        } else {
          var tmp = Encoding.getByName(charset);
          if (tmp == null) {
            throw ArgumentError(
                'Cannot find encoding for charset: ${Error.safeToString(charset)}');
          }
          realEncoding = tmp;
        }
      }
    } else {
      if (contentType == null) {
        contentType = "text/plain; charset=${encoding.name}";
      }
      realEncoding = encoding;
    }

    _init(value,
        headers: headers, encoding: realEncoding, contentType: contentType);
  }

  @override
  void write(HttpClientRequest request) {
    var contentType = ContentType.parse(this.contentType);
    request.headers.contentType = ContentType(
        contentType.primaryType, contentType.subType,
        charset: contentType.charset ?? encoding?.name);
    request.write(value);
  }
}

class JsonPayload with Payload {
  JsonPayload(
    Object? value, {
    Encoding encoding = utf8,
    String contentType = "application/json",
    String encode(Object? value)?,
    Multimap<String, String>? headers,
    String? filename,
  }) {
    encode = encode ?? jsonEncode;
    value = encode(value);

    _init(value,
        headers: headers, encoding: encoding, contentType: contentType);
  }

  @override
  void write(HttpClientRequest request) {
    var contentType = ContentType.parse(this.contentType);
    request.headers.contentType = ContentType(
        contentType.primaryType, contentType.subType,
        charset: contentType.charset ?? encoding?.name);
    request.write(value);
  }
}
