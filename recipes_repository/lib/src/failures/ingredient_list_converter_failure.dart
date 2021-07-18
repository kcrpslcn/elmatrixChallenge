import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:recipes_repository/recipes_repository.dart';

part 'ingredient_list_converter_failure.freezed.dart';

@freezed
class IngredientListConverterFailure with _$IngredientListConverterFailure {
  const factory IngredientListConverterFailure.badJsonType(Type type) = BadType;
  const factory IngredientListConverterFailure.ingredientListInvalid(
      IngredientList ingredientList) = IngredientListInvalid;
  const factory IngredientListConverterFailure.decodeFailure(
      String ingredientJson, Object? error) = DecodeFailure;
  const factory IngredientListConverterFailure.unknownError(Object? error) =
      UnknownIngredientListError;
}
