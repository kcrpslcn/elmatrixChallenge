import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:recipes_repository/recipes_repository.dart';

part 'recipes_event.dart';
part 'recipes_state.dart';
part 'recipes_bloc.freezed.dart';

class RecipesBloc extends Bloc<RecipesEvent, RecipesState> {
  final RecipesRepository _recipesRepository;
  StreamSubscription? _recipesSubscription;

  RecipesBloc({required RecipesRepository recipesRepository})
      : _recipesRepository = recipesRepository,
        super(RecipesState.recipesNotLoaded());

  @override
  Stream<RecipesState> mapEventToState(RecipesEvent event) async* {
    yield* event.map(loadRecipes: (event) async* {
      yield* _mapLoadRecipesToState();
    }, addRecipe: (event) async* {
      yield* _mapAddRecipeToState(event);
    }, updateRecipe: (event) async* {
      yield* _mapUpdateRecipeToState(event);
    }, deleteRecipe: (event) async* {
      yield* _mapDeleteRecipeToState(event);
    }, recipesUpdated: (event) async* {
      yield* _mapRecipesUpdateToState(event);
    });
  }

  Stream<RecipesState> _mapLoadRecipesToState() async* {
    _recipesSubscription?.cancel();
    _recipesSubscription = _recipesRepository.recipes().listen(
          (recipes) => add(RecipesUpdated(recipes)),
        );
  }

  Stream<RecipesState> _mapAddRecipeToState(AddRecipe event) async* {
    _recipesRepository.addNewRecipe(event.recipe);
  }

  Stream<RecipesState> _mapUpdateRecipeToState(UpdateRecipe event) async* {
    _recipesRepository.updateRecipe(event.updatedRecipe);
  }

  Stream<RecipesState> _mapDeleteRecipeToState(DeleteRecipe event) async* {
    _recipesRepository.deleteRecipe(event.recipe);
  }

  Stream<RecipesState> _mapRecipesUpdateToState(RecipesUpdated event) async* {
    yield RecipesLoaded(event.recipes);
  }

  @override
  Future<void> close() {
    _recipesSubscription?.cancel();
    return super.close();
  }
}
