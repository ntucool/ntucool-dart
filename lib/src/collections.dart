import 'dart:collection' show MapBase;

class DefaultMap<K, V> extends MapBase<K, V> {
  final _inner = <K, V>{};
  final V Function() ifAbsent;

  DefaultMap(this.ifAbsent);

  @override
  V operator [](covariant K key) => _inner.putIfAbsent(key, ifAbsent);

  @override
  void operator []=(K key, V value) => _inner[key] = value;

  @override
  void clear() => _inner.clear();

  @override
  Iterable<K> get keys => _inner.keys;

  @override
  V? remove(Object? key) => _inner.remove(key);
}
