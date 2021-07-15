part of 'recipes_bloc.dart';

@freezed
class RecipesEvent with _$RecipesEvent {
  const factory RecipesEvent.loadRecipes() = LoadRecipes;
  const factory RecipesEvent.addRecipe(Recipe recipe) = AddRecipe;
  const factory RecipesEvent.updateRecipe(Recipe updatedRecipe) = UpdateRecipe;
  const factory RecipesEvent.deleteRecipe(Recipe recipe) = DeleteRecipe;
  const factory RecipesEvent.recipesUpdated(List<Recipe> recipes) =
      RecipesUpdated;
}
