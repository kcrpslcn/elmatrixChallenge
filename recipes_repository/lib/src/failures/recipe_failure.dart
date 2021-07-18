import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe_failure.freezed.dart';

@freezed
class RecipeFailure with _$RecipeFailure {
  const factory RecipeFailure.fromJsonError(Map<String, dynamic> json) =
      FromJsonError;
  const factory RecipeFailure.unknownError(Object? error) = UnknownError;
}
