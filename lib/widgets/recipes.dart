import 'package:elmatrix_niclas/blocs/recipes/recipes_bloc.dart';
import 'package:elmatrix_niclas/screens/screens.dart';
import 'package:elmatrix_niclas/widgets/recipe_failure_snack_bar.dart';
import 'package:elmatrix_niclas/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Recipes extends StatelessWidget {
  Recipes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RecipesBloc, RecipesState>(
      listener: (context, state) {
        if (state is RecipesLoaded && state.failures.isNotEmpty)
          _showRecipeFailureSnackBar(context, state);
      },
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

  Future<void> _showRecipeFailureSnackBar(
      BuildContext context, RecipesLoaded state) async {
    ScaffoldMessenger.of(context).showSnackBar(
      RecipeFailureSnackBar(
          failures: state.failures,
          onShow: () async {
            await showDialog(
              context: context,
              builder: (BuildContext context) => SimpleDialog(
                title: const Text('Recipes with an error state'),
                children: <Widget>[
                  ...state.failures
                      .map((e) => e.map(
                          fromJsonError: (error) => Card(
                                color: Colors.redAccent,
                                child: Text('JSON error! json: ${error.json}'),
                              ),
                          unknownError: (error) =>
                              Text('Unknown Error! ${error.error.toString()}')))
                      .toList()
                ],
              ),
            );
          }),
    );
  }
}
