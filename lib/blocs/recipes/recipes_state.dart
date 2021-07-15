part of 'recipes_bloc.dart';

@freezed
class RecipesState with _$RecipesState {
  const factory RecipesState.recipesLoading() = RecipesLoading;
  const factory RecipesState.recipesLoaded(List<Recipe> recipes) =
      RecipesLoaded;
  const factory RecipesState.recipesNotLoaded() = RecipesNotLoaded;
}
