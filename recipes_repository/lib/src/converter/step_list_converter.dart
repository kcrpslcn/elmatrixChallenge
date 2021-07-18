import 'package:json_annotation/json_annotation.dart';
import 'package:recipes_repository/recipes_repository.dart';
import 'package:recipes_repository/src/failures/step_list_converter_failure.dart';

/// Can throw [StepListConverterFailure]s.
class CustomStepListConverter
    implements JsonConverter<StepList, List<dynamic>> {
  const CustomStepListConverter();

  @override
  StepList fromJson(List<dynamic> json) {
    if (json.whereType<String>().length < json.length)
      throw StepListConverterFailure.badJsonType(json.runtimeType);
    else
      return StepList(json.map((e) => StepModel(e)).toList());
  }

  @override
  List<dynamic> toJson(StepList stepList) {
    if (stepList.steps == null)
      throw StepListConverterFailure.stepListInvalid(stepList);
    return stepList.steps!.map<String>((e) => e.name).toList();
  }
}
