// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:recipes_repository/recipes_repository.dart';

import 'models/models.dart';

abstract class RecipesRepository {
  Future<Either<RecipeFailure, void>> addNewRecipe(Recipe recipe);

  Future<Either<RecipeFailure, void>> deleteRecipe(Recipe recipe);

  Stream<List<Either<RecipeFailure, Recipe>>> recipes();

  Future<Either<RecipeFailure, void>> updateRecipe(Recipe recipe);

  Future<Either<RecipeFailure, String>> uploadImage(File image);
}
