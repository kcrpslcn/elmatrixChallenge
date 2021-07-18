import 'package:flutter/foundation.dart';

@immutable
abstract class MinMaxList<T> {
  final int maxCount;
  final int minCount;
  final List<T> _list;

  get canAdd => _list.length + 1 <= maxCount;
  get valid => _list.length >= minCount && _list.length <= maxCount;

  const MinMaxList(this._list, this.minCount, this.maxCount)
      : assert(minCount <= maxCount);
}
