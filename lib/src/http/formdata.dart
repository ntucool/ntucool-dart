import 'dart:convert' show Encoding;
import 'dart:io' show HttpHeaders;

import 'package:quiver/collection.dart' show Multimap;
import 'package:tuple/tuple.dart' show Tuple2, Tuple3;

import 'helpers.dart' show mapToQuery;
import 'payload.dart' show Payload, StringPayload;

/// Helper class for multipart/form-data and
/// application/x-www-form-urlencoded body generation.
class FormData {
  var fields =
      <Tuple3<Multimap<String, String>, Map<String, String>, Object?>>[];
  var isMultipart = false;
  var isProcessed = false;
  late bool quoteFields;
  String? charset;

  FormData(Object? fields, {bool quoteFields = true, String? charset}) {
    this.quoteFields = quoteFields;
    this.charset = charset;

    if (fields is Map<String, Object?>) {
      fields.forEach((key, value) {
        addField(key, value);
      });
    } else if (fields is Iterable<Tuple2<String, Object?>>) {
      fields.forEach((element) {
        addField(element.item1, element.item2);
      });
    } else {
      throw ArgumentError.value(fields, 'fields');
    }
  }

  void addField(
    String name,
    Object? value, {
    String? contentType,
    String? filename,
    String? contentTransferEncoding,
  }) {
    var typeOptions = Multimap<String, String>();
    typeOptions.add('name', name);

    if (filename != null) {
      typeOptions.removeAll('filename');
      typeOptions.add('filename', filename);
    }

    var headers = <String, String>{};
    if (contentType != null) {
      headers[HttpHeaders.contentTypeHeader] = contentType;
      isMultipart = true;
    }
    if (contentTransferEncoding != null) {
      headers["Content-Transfer-Encoding"] = contentTransferEncoding;
      isMultipart = true;
    }

    fields.add(Tuple3(typeOptions, headers, value));
  }

  StringPayload _genFormUrlencoded() {
    var data = Multimap<String, String>();
    for (var element in fields) {
      var typeOptions = element.item1;
      var value = element.item3;
      data.add(typeOptions['name'].first, value.toString());
    }

    charset = this.charset ?? 'utf-8';

    var contentType;
    if (charset == 'utf-8') {
      contentType = "application/x-www-form-urlencoded";
    } else {
      contentType = "application/x-www-form-urlencoded; " "charset=$charset";
    }

    var encoding = Encoding.getByName(charset)!;

    return StringPayload(
        mapToQuery(data.asMap().map((key, value) => MapEntry(key, value))),
        encoding: encoding,
        contentType: contentType);
  }

  Payload call() {
    if (isMultipart) {
      throw UnimplementedError();
    } else {
      return _genFormUrlencoded();
    }
  }
}
