import 'max_list.dart';

class StepList extends MinMaxList<StepModel> {
  static const int minSteps = 1;
  static const int maxSteps = 10;
  final List<StepModel> _list;
  const StepList(this._list) : super(_list, minSteps, maxSteps);

  List<StepModel>? get steps => valid ? _list : null;
  void addStep(StepModel step) {
    if (canAdd) _list.add(step);
  }

  void updateStep(StepModel source, StepModel target) {
    final index = _list.indexOf(source);
    if (index >= 0) _list.replaceRange(index, index + 1, [target]);
  }

  void removeStep(StepModel step) {
    _list.remove(step);
  }
}

class StepModel {
  final String name;
  const StepModel(this.name);
}
