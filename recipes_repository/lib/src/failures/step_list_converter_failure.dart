import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:recipes_repository/recipes_repository.dart';

part 'step_list_converter_failure.freezed.dart';

@freezed
class StepListConverterFailure with _$StepListConverterFailure {
  const factory StepListConverterFailure.badJsonType(Type type) = BadType;
  const factory StepListConverterFailure.stepListInvalid(StepList stepList) =
      StepListInvalid;
  const factory StepListConverterFailure.unknownError(Object? error) =
      UnknownError;
}
