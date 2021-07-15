import 'package:json_annotation/json_annotation.dart';
import 'package:recipes_repository/recipes_repository.dart';
import 'dart:convert' as convert;

class CustomIngredientListConverter
    implements JsonConverter<IngredientList, List<dynamic>> {
  const CustomIngredientListConverter();

  @override
  IngredientList fromJson(List<dynamic> json) {
    return IngredientList(json.map((e) {
      final x = convert.json.decode(e);
      return Ingredient.fromJson(x);
    }).toList());
  }

  @override
  List<dynamic> toJson(IngredientList json) {
    if (json.ingredients != null) {
      return json.ingredients!
          .map<String>((e) => convert.json.encode(e.toJson()))
          .toList();
    } else {
      throw Error();
    }
  }
}
