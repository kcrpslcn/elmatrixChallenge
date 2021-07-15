// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'entities/entities.dart';
import 'models/models.dart';
import 'recipes_repository.dart';
import 'package:path/path.dart';

class FirebaseRecipesRepository implements RecipesRepository {
  final recipeCollection = FirebaseFirestore.instance.collection('recipes');
  final storage = FirebaseStorage.instance;

  @override
  Future<void> addNewRecipe(Recipe recipe) {
    return recipeCollection
        .doc(recipe.id)
        .set((recipe.toEntity().toDocument()));
  }

  @override
  Future<void> deleteRecipe(Recipe recipe) async {
    return recipeCollection.doc(recipe.id).delete();
  }

  @override
  Stream<List<Recipe>> recipes() {
    return recipeCollection.snapshots().map((snapshot) {
      final x = snapshot.docs
          .map((doc) => Recipe.fromEntity(RecipeEntity.fromSnapshot(doc)))
          .toList();
      return x;
    });
  }

  @override
  Future<void> updateRecipe(Recipe recipe) {
    return recipeCollection
        .doc(recipe.id)
        .update(recipe.toEntity().toDocument());
  }

  @override
  Future<String> uploadImage(File image) async {
    final filename = basename(image.path);
    final storageReference = storage.ref().child('images/$filename');
    final uploadTask = storageReference.putFile(image);
    final x = await uploadTask.whenComplete(() {});
    var imageUrl = await x.ref.getDownloadURL();
    return imageUrl;
  }
}
