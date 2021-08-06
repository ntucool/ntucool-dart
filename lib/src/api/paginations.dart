import 'dart:async' show Future, Stream, StreamSubscription;

import 'package:quiver/collection.dart' show Multimap;
import 'package:tuple/tuple.dart' show Tuple2, Tuple3;

import '../exceptions.dart' show ApiException;
import '../http/http.dart' show Response, Session;
import '../utils.dart' show requestJson;

class Pagination<E> extends Stream<E> {
  Session session;
  String method;
  Uri base;
  String? reference;
  List<Object?>? paramsList;
  Object? data;
  Object? json;
  Object? cookies;
  Object? headers;
  E Function(dynamic attributes)? constructor;
  Multimap<String, Multimap<String, Object>>? links;
  List<E> values = [];

  Pagination(this.session, this.method, this.base,
      {this.reference,
      this.paramsList,
      this.data,
      this.json,
      this.cookies,
      this.headers,
      this.constructor});

  Future<Tuple2<Multimap<String, Multimap<String, Object>>?, List<E>?>> request(
      String key) async {
    Tuple3<dynamic, Response, ApiException?> tmp;
    var links = this.links;
    if (links == null) {
      tmp = await requestJson(session, method, base,
          reference: reference,
          paramsList: paramsList,
          data: data,
          json: json,
          cookies: cookies,
          headers: headers);
    } else if (links.containsKey(key)) {
      // TODO: What should still be sent?
      var url = links[key].first['url'].first as Uri;
      tmp = await requestJson(session, method, url);
    } else {
      return Tuple2(null, null);
    }
    var values = tmp.item1 as List<dynamic>;
    var response = tmp.item2;
    var constructor = this.constructor ?? (e) => e;
    var cvalues = values.map((e) => constructor(e)).toList();
    return Tuple2(response.links, cvalues);
  }

  Future<List<E>?> requestCurrent({bool update = true}) async {
    var tmp = await request('current');
    var links = tmp.item1;
    var values = tmp.item2;
    if (update) {
      if (links != null) {
        this.links = links;
      }
    }
    return values;
  }

  Future<List<E>?> requestNext({bool update = true}) async {
    var tmp = await request('next');
    var links = tmp.item1;
    var values = tmp.item2;
    if (update) {
      if (links != null) {
        this.links = links;
      }
      if (values != null) {
        this.values.addAll(values);
      }
    }
    return values;
  }

  Future<List<E>?> requestPrev({bool update = true}) async {
    var tmp = await request('prev');
    var links = tmp.item1;
    var values = tmp.item2;
    if (update) {
      if (links != null) {
        this.links = links;
      }
      if (values != null) {
        this.values.insertAll(0, values);
      }
    }
    return values;
  }

  Future<List<E>?> requestFirst({bool update = true}) async {
    var tmp = await request('first');
    var links = tmp.item1;
    var values = tmp.item2;
    if (update) {
      if (links != null) {
        this.links = links;
      }
    }
    return values;
  }

  Future<List<E>?> requestLast({bool update = true}) async {
    var tmp = await request('last');
    var links = tmp.item1;
    var values = tmp.item2;
    if (update) {
      if (links != null) {
        this.links = links;
      }
    }
    return values;
  }

  @override
  StreamSubscription<E> listen(void Function(E event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return (() async* {
      for (var value in this.values) {
        yield value;
      }
      var values = await requestNext();
      while (values != null) {
        for (var value in values) {
          yield value;
        }
        values = await requestNext();
      }
    })()
        .listen(onData,
            onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }
}
