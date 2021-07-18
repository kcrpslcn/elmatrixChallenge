import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:recipes_repository/recipes_repository.dart';

part 'recipe_failure.freezed.dart';

@freezed
class RecipeFailure with _$RecipeFailure {
  const factory RecipeFailure.fromJsonError(
      Map<String, dynamic> json, Object? error) = FromJsonError;
  const factory RecipeFailure.toJsonError(Recipe recipe, Object? error) =
      ToJsonError;
  const factory RecipeFailure.deleteRecipeFailed(Object? error) =
      DeleteRecipeFailed;
  const factory RecipeFailure.imageUploadFailed(Object? error) =
      ImageUploadFailed;
  const factory RecipeFailure.unknownError(Object? error) = UnknownRecipeError;
}
