// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'models/models.dart';

abstract class RecipesRepository {
  Future<void> addNewRecipe(Recipe recipe);

  Future<void> deleteRecipe(Recipe recipe);

  Stream<List<Recipe>> recipes();

  Future<void> updateRecipe(Recipe recipe);

  Future<String> uploadImage(File image);
}
