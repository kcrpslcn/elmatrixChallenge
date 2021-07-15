import 'package:json_annotation/json_annotation.dart';
import 'package:recipes_repository/recipes_repository.dart';

class CustomStepListConverter
    implements JsonConverter<StepList, List<dynamic>> {
  const CustomStepListConverter();

  @override
  StepList fromJson(List<dynamic> json) {
    return StepList(json.map((e) => StepModel(e)).toList());
  }

  @override
  List<dynamic> toJson(StepList json) {
    if (json.steps != null) {
      return json.steps!.map<String>((e) => e.name).toList();
    } else {
      throw Error();
    }
  }
}
