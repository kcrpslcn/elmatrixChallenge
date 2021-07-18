import 'package:meta/meta.dart';
import 'package:recipes_repository/src/models/ingredient_list.dart';
import 'package:recipes_repository/src/models/step_list.dart';
import 'package:uuid/uuid.dart';
import '../entities/entities.dart';

@immutable
class Recipe {
  final String id;
  final String title;
  final String? subtitle;
  final String? photoUri;
  final IngredientList ingredients;
  final StepList steps;
  final int numberOfCookings;

  Recipe({
    required this.title,
    String? id,
    String? subtitle,
    String? photoUri,
    IngredientList ingredients = const IngredientList([]),
    StepList steps = const StepList([]),
    int numberOfCookings = 0,
  })  : this.subtitle = subtitle ?? '',
        this.photoUri = photoUri,
        this.ingredients = ingredients,
        this.steps = steps,
        this.numberOfCookings = numberOfCookings,
        this.id = id ?? Uuid().v4();

  Recipe copyWith(
      {String? title,
      String? subtitle,
      String? photoUri,
      IngredientList? ingredients,
      StepList? steps,
      int? numberOfCookings}) {
    return Recipe(
      id: id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      photoUri: photoUri ?? this.photoUri,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      numberOfCookings: numberOfCookings ?? this.numberOfCookings,
    );
  }

  @override
  int get hashCode {
    return title.hashCode ^
        subtitle.hashCode ^
        photoUri.hashCode ^
        numberOfCookings.hashCode ^
        id.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Recipe &&
            runtimeType == other.runtimeType &&
            title == other.title &&
            subtitle == other.subtitle &&
            photoUri == other.photoUri &&
            numberOfCookings == other.numberOfCookings &&
            id == other.id;
  }

  // Could be replaced with toJson, instead of returning an entity
  // we do not need to know about the entity?
  // Same goes for fromEntity, this could be fromSnapshot
  RecipeEntity toEntity() {
    return RecipeEntity(
      id: id,
      title: title,
      subtitle: subtitle,
      photoUri: photoUri,
      ingredients: ingredients,
      steps: steps,
      numberOfCookings: numberOfCookings,
    );
  }

  static Recipe fromEntity(RecipeEntity entity) {
    return Recipe(
      id: entity.id,
      title: entity.title,
      subtitle: entity.subtitle,
      photoUri: entity.photoUri,
      ingredients: entity.ingredients,
      steps: entity.steps,
      numberOfCookings: entity.numberOfCookings,
    );
  }
}
