import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:elmatrix_niclas/blocs/recipes/recipes_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:recipes_repository/recipes_repository.dart';

part 'stats_event.dart';
part 'stats_state.dart';
part 'stats_bloc.freezed.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  late StreamSubscription _recipesSubscription;

  StatsBloc({required RecipesBloc recipesBloc})
      : super(StatsState.statsLoading()) {
    final recipesState = recipesBloc.state;
    if (recipesState is RecipesLoaded) add(StatsUpdated(recipesState.recipes));
    _recipesSubscription = recipesBloc.stream.listen((state) {
      if (state is RecipesLoaded) {
        add(StatsUpdated(state.recipes));
      }
    });
  }

  @override
  Stream<StatsState> mapEventToState(StatsEvent event) async* {
    yield* event.map(statsUpdated: (event) async* {
      final totalRecipes = event.recipes.length;
      final cookedRecipes = event.recipes
          .where((recipe) => recipe.numberOfCookings > 0)
          .toList()
          .length;
      final totalCookingSessions = event.recipes.fold<int>(0,
          (previousValue, element) => previousValue + element.numberOfCookings);
      yield StatsLoaded(
        totalRecipes: totalRecipes,
        cookedRecipes: cookedRecipes,
        totalCookingSessions: totalCookingSessions,
      );
    });
    // if (event is StatsUpdated) {
    //   final totalRecipes = event.recipes.length;
    //   final cookedRecipes = event.recipes
    //       .where((recipe) => recipe.numberOfCookings > 0)
    //       .toList()
    //       .length;
    //   final totalCookingSessions = event.recipes.fold<int>(0,
    //       (previousValue, element) => previousValue + element.numberOfCookings);
    //   yield StatsLoaded(
    //     totalRecipes: totalRecipes,
    //     cookedRecipes: cookedRecipes,
    //     totalCookingSessions: totalCookingSessions,
    //   );
    // }
  }

  @override
  Future<void> close() {
    _recipesSubscription.cancel();
    return super.close();
  }
}
