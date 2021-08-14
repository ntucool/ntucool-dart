import 'dart:async';

class CompleterLock {
  Future? _future;

  Future<T> acquire<T>(FutureOr<T> computation()) async {
    var future = _future;

    // acquire
    var completer = Completer();
    _future = completer.future;

    if (future != null) {
      await future;
    }

    var result = await computation();

    // release
    if (identical(_future, completer.future)) {
      _future = null;
    }
    completer.complete();

    return result;
  }

  /// Return true if the lock is acquired.
  bool get locked => _future != null;
}

class FutureChainLock {
  Future _future = Future.value(null);

  Future<T> acquire<T>(FutureOr<T> computation()) {
    var previous = _future;
    var current = Future(() async {
      await previous;
      return computation();
    });
    _future = current;
    return current;
  }
}

main(List<String> args) async {
  var lock = FutureChainLock();

  for (var i = 5; i >= 0; i--) {
    lock.acquire(() async {
      await Future.delayed(Duration(seconds: i), () => print(i));
      await Future.delayed(Duration(seconds: i), () => print(i));
      await Future.delayed(Duration(seconds: 1), () => print(i));
    });
  }
  print('begin');
}
