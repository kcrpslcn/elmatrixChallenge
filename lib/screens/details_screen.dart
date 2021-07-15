import 'dart:io';

import 'package:elmatrix_niclas/blocs/image/image_bloc.dart';
import 'package:elmatrix_niclas/blocs/recipes/recipes_bloc.dart';
import 'package:elmatrix_niclas/screens/screens.dart';
import 'package:elmatrix_niclas/screens/steps_details_screen.dart';
import 'package:elmatrix_niclas/widgets/loading_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipes_repository/recipes_repository.dart';

class DetailsScreen extends StatefulWidget {
  final String id;

  DetailsScreen({Key? key, required this.id}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ImageBloc>(
      create: (context) {
        return ImageBloc(
          recipesRepository: FirebaseRecipesRepository(),
        );
      },
      child: BlocBuilder<RecipesBloc, RecipesState>(
        builder: (context, state) {
          return state.maybeMap(
              recipesLoaded: (state) {
                //TODO bad state no element
                final recipe = state.recipes
                    .firstWhere((recipe) => recipe.id == widget.id);
                if (recipe.photoUri != null)
                  context.read<ImageBloc>().add(LoadFromUri(recipe.photoUri!));
                return Scaffold(
                  appBar: AppBar(
                    title: Text('Recipe Details'),
                    actions: [
                      IconButton(
                        tooltip: 'Delete Recipe',
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          context.read<RecipesBloc>().add(DeleteRecipe(recipe));
                          Navigator.of(context).pop(recipe);
                        },
                      )
                    ],
                  ),
                  body: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: ListView(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.only(
                                      top: 8.0,
                                      bottom: 16.0,
                                    ),
                                    child: Text(
                                      recipe.title,
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                  ),
                                  Text(
                                    recipe.subtitle ?? '',
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                ],
                              ),
                            ),
                            BlocConsumer<ImageBloc, ImageState>(
                                listener: (context, state) {
                              return state.maybeMap<void>(
                                  imageUploaded: (state) {
                                    if (recipe.photoUri != state.uri)
                                      context.read<RecipesBloc>().add(
                                          UpdateRecipe(recipe.copyWith(
                                              photoUri: state.uri)));
                                  },
                                  orElse: () {});
                            }, builder: (context, state) {
                              return state.maybeMap(
                                  imagePicked: (state) => Image.file(
                                      state.image,
                                      width: 150,
                                      height: 150),
                                  imageUploaded: (state) => GestureDetector(
                                        onTap: () => openEditPictureDialog(
                                            context, recipe),
                                        child: Image.network(
                                          state.uri,
                                          width: 150,
                                          height: 150,
                                        ),
                                      ),
                                  imageUploading: (_) => LoadingIndicator(),
                                  orElse: () => Column(
                                        children: [
                                          ElevatedButton(
                                            child: Text('Choose Image'),
                                            onPressed: () =>
                                                chooseFile(context, recipe),
                                          ),
                                          ElevatedButton(
                                            child: Text('Take Image'),
                                            onPressed: () =>
                                                takeImage(context, recipe),
                                          )
                                        ],
                                      ));
                            }),
                          ],
                        ),
                        Container(
                          height: 12,
                        ),
                        const Padding(
                            padding: EdgeInsets.all(12),
                            child: Text('Ingredients')),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount:
                                recipe.ingredients.ingredients?.length ?? 0,
                            itemBuilder: (BuildContext context, int index) {
                              return Text(
                                  '${recipe.ingredients.ingredients?[index].name}');
                            }),
                        const Padding(
                            padding: EdgeInsets.all(12), child: Text('Steps')),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: recipe.steps.steps?.length ?? 0,
                            itemBuilder: (BuildContext context, int index) {
                              return Text('${recipe.steps.steps?[index].name}');
                            }),
                        Container(height: 12),
                        TextButton(
                            onPressed: () => {
                                  context.read<RecipesBloc>().add(UpdateRecipe(
                                      recipe.copyWith(
                                          numberOfCookings:
                                              recipe.numberOfCookings + 1))),
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return StepsDetailsScreen(id: widget.id);
                                  }))
                                },
                            child: Text('Cook now!')),
                      ],
                    ),
                  ),
                  floatingActionButton: FloatingActionButton(
                    tooltip: 'Edit Recipe',
                    child: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return AddEditRecipeScreen(
                              onSave: (title, subtitle, ingredients, steps) {
                                context.read<RecipesBloc>().add(
                                      UpdateRecipe(recipe.copyWith(
                                          title: title,
                                          subtitle: subtitle,
                                          ingredients: ingredients,
                                          steps: steps,
                                          numberOfCookings:
                                              recipe.numberOfCookings)),
                                    );
                              },
                              isEditing: true,
                              recipe: recipe,
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
              orElse: () => throw StateError(
                  'Cannot render details without a valid recipe'));
        },
      ),
    );
  }

  Future chooseFile(BuildContext context, Recipe recipe) async {
    await _picker.getImage(source: ImageSource.gallery).then((image) {
      if (image != null) {
        context.read<ImageBloc>().add(PickImage(File(image.path)));
        uploadFile(context, recipe, File(image.path));
      }
    });
  }

  Future<void> takeImage(BuildContext context, Recipe recipe) async {
    await _picker.getImage(source: ImageSource.camera).then((image) {
      if (image != null) {
        context.read<ImageBloc>().add(PickImage(File(image.path)));
        uploadFile(context, recipe, File(image.path));
      }
    });
  }

  Future<void> uploadFile(
      BuildContext context, Recipe recipe, File image) async {
    context.read<ImageBloc>().add(UploadImage(File(image.path)));
  }

  // use enum instead of bool
  void openEditPictureDialog(BuildContext context, Recipe recipe) async {
    switch (await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Edit Picture'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text('Take Picture'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text('Select Picture'),
              ),
            ],
          );
        })) {
      case true:
        return takeImage(context, recipe);
      case false:
        return chooseFile(context, recipe);
      case null:
        break;
    }
  }
}
