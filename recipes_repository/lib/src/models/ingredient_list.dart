import 'package:json_annotation/json_annotation.dart';

import 'min_max_list.dart';

part 'ingredient_list.g.dart';

class IngredientList extends MinMaxList<Ingredient> {
  static const int minIngredients = 1;
  static const int maxIngredients = 30;
  final List<Ingredient> _list;
  const IngredientList(this._list)
      : super(_list, minIngredients, maxIngredients);

  List<Ingredient>? get ingredients => valid ? _list : null;
  void addIngredient(Ingredient ingredient) {
    if (canAdd) _list.add(ingredient);
  }

  void updateIngredient(Ingredient source, Ingredient target) {
    final index = _list.indexOf(source);
    if (index >= 0) _list.replaceRange(index, index + 1, [target]);
  }

  void removeIngredient(Ingredient ingredient) {
    _list.remove(ingredient);
  }
}

@JsonSerializable()
class Ingredient {
  final String name;
  final int amount;
  final String measurement;
  const Ingredient(this.name, this.amount, this.measurement);

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientToJson(this);

  @override
  String toString() {
    return 'Name: $name , Measurement: $measurement, Amount: $amount';
  }
}
