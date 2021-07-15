import 'package:elmatrix_niclas/blocs/recipes/recipes_bloc.dart';
import 'package:elmatrix_niclas/screens/screens.dart';
import 'package:elmatrix_niclas/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Recipes extends StatelessWidget {
  Recipes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipesBloc, RecipesState>(
      builder: (context, state) {
        return state.maybeMap(
            recipesLoading: (state) => LoadingIndicator(),
            recipesLoaded: (state) {
              final recipes = state.recipes;
              return ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  return RecipeItem(
                    recipe: recipe,
                    onDismissed: (direction) {
                      context.read<RecipesBloc>().add(DeleteRecipe(recipe));
                      ScaffoldMessenger.of(context).showSnackBar(
                        DeleteRecipeSnackBar(
                          recipe: recipe,
                          onUndo: () {
                            context.read<RecipesBloc>().add(AddRecipe(recipe));
                          },
                        ),
                      );
                    },
                    onTap: () async {
                      final removedRecipe = await Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) {
                          return DetailsScreen(id: recipe.id);
                        }),
                      );
                      if (removedRecipe != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          DeleteRecipeSnackBar(
                            recipe: recipe,
                            onUndo: () {
                              context
                                  .read<RecipesBloc>()
                                  .add(AddRecipe(recipe));
                            },
                          ),
                        );
                      }
                    },
                  );
                },
              );
            },
            orElse: () => Container());
      },
    );
  }
}
