part of 'stats_bloc.dart';

@freezed
class StatsState with _$StatsState {
  const factory StatsState.statsLoading() = StatsLoading;
  const factory StatsState.statsLoaded(
      {required int totalRecipes,
      required int cookedRecipes,
      required int totalCookingSessions}) = StatsLoaded;
}
