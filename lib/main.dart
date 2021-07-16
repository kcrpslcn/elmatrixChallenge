import 'package:elmatrix_niclas/blocs/recipes/recipes_bloc.dart';
import 'package:elmatrix_niclas/blocs/stats/stats_bloc.dart';
import 'package:elmatrix_niclas/blocs/tab/tab_bloc.dart';
import 'package:elmatrix_niclas/screens/screens.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes_repository/recipes_repository.dart';
import 'package:user_repository/user_repository.dart';

import 'blocs/authentication/authentication_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(RecipeApp());
}

class RecipeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) {
            return AuthenticationBloc(
              userRepository: FirebaseUserRepository(),
            )..add(AppStarted());
          },
        ),
        BlocProvider<RecipesBloc>(
          create: (context) {
            return RecipesBloc(
              recipesRepository: FirebaseRecipesRepository(),
            )..add(LoadRecipes());
          },
        ),
      ],
      child: MaterialApp(
        title: 'Elmatrix Recipes',
        routes: {
          '/': (context) {
            return BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                return state.map(
                    initial: (_) => Center(child: CircularProgressIndicator()),
                    authenticating: (_) =>
                        Center(child: CircularProgressIndicator()),
                    authenticated: (state) => MultiBlocProvider(
                          providers: [
                            BlocProvider<TabBloc>(
                              create: (context) => TabBloc(),
                            ),
                            BlocProvider<StatsBloc>(
                              create: (context) => StatsBloc(
                                recipesBloc: context.read<RecipesBloc>(),
                              ),
                            ),
                          ],
                          child: HomeScreen(),
                        ),
                    unauthenticated: (state) => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                                child: Text(
                                    'Could not authenticate with Firestore')),
                            ElevatedButton(
                              onPressed: () => context
                                  .read<AuthenticationBloc>()
                                  .add(AuthenticationEvent.login()),
                              child: const Text('Login'),
                            ),
                          ],
                        ),
                    authenticationFailed: (state) {
                      return Center(
                        child: Text(state.failure.map(
                            firebaseOperationNotAllowed: (name) => '''
                            Backend operation was not allowed!
                            Please contact support!

                            Operation name: $name
                            ''',
                            notLoggedIn: (_) => 'There is no logged in user.',
                            unknownError: (failure) => '''
                            There was an unknown error!
                            Please contact support!

                            Error: ${failure.error}
                            ''')),
                      );
                    });
              },
            );
          },
          '/addRecipe': (context) {
            return AddEditRecipeScreen(
              onSave: (title, subtitle, ingredients, steps) {
                context.read<RecipesBloc>().add(AddRecipe(Recipe(
                    title: title,
                    subtitle: subtitle,
                    ingredients: ingredients,
                    steps: steps,
                    numberOfCookings: 0)));
              },
              isEditing: false,
            );
          },
        },
      ),
    );
  }
}
