import 'dart:convert' as convert;

import 'package:json_annotation/json_annotation.dart';
import 'package:recipes_repository/recipes_repository.dart';
import 'package:recipes_repository/src/failures/ingredient_list_converter_failure.dart';

class CustomIngredientListConverter
    implements JsonConverter<IngredientList, List<dynamic>> {
  const CustomIngredientListConverter();

  @override
  IngredientList fromJson(List<dynamic> json) {
    if (json.whereType<String>().length < json.length)
      throw IngredientListConverterFailure.badJsonType(json.runtimeType);
    return IngredientList(json.map((ingredientJson) {
      try {
        final decodedJson = convert.json.decode(ingredientJson);
        return Ingredient.fromJson(decodedJson);
      } on FormatException catch (e) {
        throw IngredientListConverterFailure.decodeFailure(ingredientJson, e);
      } catch (e) {
        throw IngredientListConverterFailure.unknownError(e);
      }
    }).toList());
  }

  @override
  List<dynamic> toJson(IngredientList ingredientList) {
    if (ingredientList.ingredients == null)
      throw IngredientListConverterFailure.ingredientListInvalid(
          ingredientList);
    return ingredientList.ingredients!
        .map<String>((e) => convert.json.encode(e.toJson()))
        .toList();
  }
}
