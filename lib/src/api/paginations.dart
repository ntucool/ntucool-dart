import 'dart:async'
    show
        EventSink,
        Future,
        FutureOr,
        Stream,
        StreamConsumer,
        StreamSubscription,
        StreamTransformer;

import 'package:quiver/collection.dart' show Multimap;
import 'package:tuple/tuple.dart' show Tuple2, Tuple3;

import '../exceptions.dart' show ApiException;
import '../http/http.dart' show Response, Session;
import '../lock.dart' show FutureChainLock;
import '../utils.dart' show requestJson;

class Pagination<T> extends Stream<T> {
  Session? session;
  String? method;
  Uri? base;
  String? reference;
  List<Object?>? paramsList;
  Object? data;
  Object? json;
  Object? cookies;
  Object? headers;
  T Function(dynamic attributes)? constructor;
  Multimap<String, Multimap<String, Object>>? links;
  List<T> values = [];

  Pagination(
    this.session,
    this.method,
    this.base, {
    this.reference,
    this.paramsList,
    this.data,
    this.json,
    this.cookies,
    this.headers,
    this.constructor,
  });

  factory Pagination.fromIterable(Iterable<T> elements) {
    var pagination = Pagination<T>(null, null, null);
    pagination.links = Multimap();
    pagination.values.addAll(elements);
    return pagination;
  }

  T operator [](int index) {
    return values[index];
  }

  final lock = FutureChainLock();

  Future<Tuple2<Multimap<String, Multimap<String, Object>>?, List<T>?>> request(
      String key) {
    return lock.acquire(() => _request(key));
  }

  Future<Tuple2<Multimap<String, Multimap<String, Object>>?, List<T>?>>
      _request(String key) async {
    Tuple3<dynamic, Response, ApiException?> tmp;
    var links = this.links;
    // print([
    //   'links',
    //   links?.asMap().map((key, value) => MapEntry(
    //       key,
    //       value
    //           .map((e) => e.asMap().map((key, value) => MapEntry(key, value)))
    //           .toList()))
    // ]);
    if (links == null) {
      tmp = await requestJson(session!, method!, base!,
          reference: reference,
          paramsList: paramsList,
          data: data,
          json: json,
          cookies: cookies,
          headers: headers);
    } else if (links.containsKey(key)) {
      // TODO: What should still be sent?
      var url = links[key].first['url'].first as Uri;
      tmp = await requestJson(session!, method!, url);
    } else {
      return Tuple2(null, null);
    }
    var values = tmp.item1 as List<dynamic>;
    var response = tmp.item2;
    var constructor = this.constructor ?? (e) => e;
    var cvalues = values.map((e) => constructor(e)).toList();
    return Tuple2(response.links, cvalues);
  }

  Future<List<T>?> requestCurrent({bool update = true}) async {
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

  Future<List<T>?> requestNext({bool update = true}) async {
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

  Future<List<T>?> requestPrev({bool update = true}) async {
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

  Future<List<T>?> requestFirst({bool update = true}) async {
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

  Future<List<T>?> requestLast({bool update = true}) async {
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

  Stream<T> get stream async* {
    var index = 0;
    while (true) {
      try {
        var value = await elementAt(index);
        yield value;
        index++;
      } on RangeError {
        break;
      }
    }
  }

  @override
  Future<bool> any(bool Function(T element) test) {
    return super.any(test);
  }

  @override
  Stream<T> asBroadcastStream(
      {void Function(StreamSubscription<T> subscription)? onListen,
      void Function(StreamSubscription<T> subscription)? onCancel}) {
    return super.asBroadcastStream(onListen: onListen, onCancel: onCancel);
  }

  @override
  Stream<E> asyncExpand<E>(Stream<E>? Function(T event) convert) {
    return super.asyncExpand(convert);
  }

  @override
  Stream<E> asyncMap<E>(FutureOr<E> Function(T event) convert) {
    return super.asyncMap(convert);
  }

  @override
  Stream<R> cast<R>() {
    return super.cast<R>();
  }

  @override
  Future<bool> contains(Object? needle) {
    return super.contains(needle);
  }

  @override
  Stream<T> distinct([bool Function(T previous, T next)? equals]) {
    return super.distinct(equals);
  }

  @override
  Future<E> drain<E>([E? futureValue]) {
    return super.drain();
  }

  @override
  Future<T> elementAt(int index) async {
    var noNext = false;
    while (true) {
      try {
        var value = this[index];
        return value;
      } on RangeError catch (e) {
        if (noNext) {
          return Future.error(e);
        }
        var values = await requestNext();
        if (values == null) {
          noNext = true;
        }
      }
    }
  }

  @override
  Future<bool> every(bool Function(T element) test) {
    return super.every(test);
  }

  @override
  Stream<S> expand<S>(Iterable<S> Function(T element) convert) {
    return super.expand<S>(convert);
  }

  @override
  Future<T> get first => super.first;

  @override
  Future<T> firstWhere(bool Function(T element) test, {T Function()? orElse}) {
    return super.firstWhere(test, orElse: orElse);
  }

  @override
  Future<S> fold<S>(S initialValue, S Function(S previous, T element) combine) {
    return super.fold<S>(initialValue, combine);
  }

  @override
  Future forEach(void Function(T element) action) {
    return super.forEach(action);
  }

  @override
  Stream<T> handleError(Function onError, {bool Function(dynamic)? test}) {
    return super.handleError(onError, test: test);
  }

  @override
  bool get isBroadcast => super.isBroadcast;

  @override
  Future<bool> get isEmpty => super.isEmpty;

  @override
  Future<String> join([String separator = ""]) {
    return super.join(separator);
  }

  @override
  Future<T> get last async {
    var index = this.values.length;
    while (true) {
      try {
        await elementAt(index);
      } on RangeError {
        return this.values.last;
      }
      index = this.values.length;
    }
  }

  @override
  Future<T> lastWhere(bool Function(T element) test, {T Function()? orElse}) {
    return super.lastWhere(test, orElse: orElse);
  }

  @override
  Future<int> get length => super.length;

  @override
  StreamSubscription<T> listen(void Function(T event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return stream.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  @override
  Stream<S> map<S>(S Function(T event) convert) {
    return super.map<S>(convert);
  }

  @override
  Future pipe(StreamConsumer<T> streamConsumer) {
    return super.pipe(streamConsumer);
  }

  @override
  Future<T> reduce(T Function(T previous, T element) combine) {
    return super.reduce(combine);
  }

  @override
  Future<T> get single => super.single;

  @override
  Future<T> singleWhere(bool Function(T element) test, {T Function()? orElse}) {
    return super.singleWhere(test, orElse: orElse);
  }

  @override
  Stream<T> skip(int count) {
    return super.skip(count);
  }

  @override
  Stream<T> skipWhile(bool Function(T element) test) {
    return super.skipWhile(test);
  }

  @override
  Stream<T> take(int count) {
    return super.take(count);
  }

  @override
  Stream<T> takeWhile(bool Function(T element) test) {
    return super.takeWhile(test);
  }

  @override
  Stream<T> timeout(Duration timeLimit,
      {void Function(EventSink<T> sink)? onTimeout}) {
    return super.timeout(timeLimit, onTimeout: onTimeout);
  }

  @override
  Future<List<T>> toList() {
    return super.toList();
  }

  @override
  Future<Set<T>> toSet() {
    return super.toSet();
  }

  @override
  Stream<S> transform<S>(StreamTransformer<T, S> streamTransformer) {
    return super.transform(streamTransformer);
  }

  @override
  Stream<T> where(bool Function(T event) test) {
    return super.where(test);
  }
}
