// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:recipes_repository/recipes_repository.dart';

import 'models/models.dart';
import 'recipes_repository.dart';

class FirebaseRecipesRepository implements RecipesRepository {
  final recipeCollection = FirebaseFirestore.instance.collection('recipes');
  final storage = FirebaseStorage.instance;

  @override
  Future<void> addNewRecipe(Recipe recipe) {
    return recipeCollection.doc(recipe.id).set((recipe.toJson()));
  }

  @override
  Future<void> deleteRecipe(Recipe recipe) async {
    return recipeCollection.doc(recipe.id).delete();
  }

  @override
  Stream<List<Either<RecipeFailure, Recipe>>> recipes() {
    return recipeCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Recipe.fromJson(doc.data())).toList());
  }

  @override
  Future<void> updateRecipe(Recipe recipe) {
    return recipeCollection.doc(recipe.id).update(recipe.toJson());
  }

  @override
  Future<String> uploadImage(File image) async {
    final filename = basename(image.path);
    final storageReference = storage.ref().child('images/$filename');
    final uploadTask = storageReference.putFile(image);
    final taskSnapshot = await uploadTask.whenComplete(() {});
    final imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }
}
