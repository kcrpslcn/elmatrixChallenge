import 'package:elmatrix_niclas/blocs/recipes/recipes_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StepsDetailsScreen extends StatelessWidget {
  final String id;

  StepsDetailsScreen({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipesBloc, RecipesState>(
      builder: (context, state) {
        return state.maybeMap(
            recipesLoaded: (state) {
              final recipe =
                  state.recipes.firstWhere((recipe) => recipe.id == id);
              return Scaffold(
                appBar: AppBar(
                  title: Text('Step Details'),
                ),
                body: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      recipe.photoUri != null
                          ? Image.network(
                              recipe.photoUri!,
                              width: 150,
                              height: 150,
                            )
                          : Container(),
                      const Center(child: Text('Steps')),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: recipe.steps.steps?.length ?? 0,
                          itemBuilder: (BuildContext context, int index) {
                            return Text(
                                'Step ${index + 1}: ${recipe.steps.steps?[index].name}');
                          }),
                    ],
                  ),
                ),
              );
            },
            orElse: () => throw StateError(
                'Cannot render step details without a valid recipe'));
      },
    );
  }
}
