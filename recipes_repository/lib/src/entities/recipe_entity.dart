import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:recipes_repository/recipes_repository.dart';
import 'package:recipes_repository/src/converter/ingredient_list_converter.dart';
import 'package:recipes_repository/src/converter/step_list_converter.dart';

part 'recipe_entity.g.dart';

@JsonSerializable()
@CustomIngredientListConverter()
@CustomStepListConverter()
class RecipeEntity extends Equatable {
  final String id;
  final String title;
  final String? subtitle;
  final String? photoUri;
  final IngredientList ingredients;
  final StepList steps;
  final int numberOfCookings;

  const RecipeEntity({
    required this.id,
    required this.title,
    this.subtitle,
    this.photoUri,
    required this.ingredients,
    required this.steps,
    required this.numberOfCookings,
  });

  factory RecipeEntity.fromJson(Map<String, dynamic> json) =>
      _$RecipeEntityFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeEntityToJson(this);

  @override
  List<Object?> get props => [id];
}
