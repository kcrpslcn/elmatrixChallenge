part of 'stats_bloc.dart';

@freezed
class StatsEvent with _$StatsEvent {
  const factory StatsEvent.statsUpdated(List<Recipe> recipes) = StatsUpdated;
}
