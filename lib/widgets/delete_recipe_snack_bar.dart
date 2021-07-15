import 'package:flutter/material.dart';
import 'package:recipes_repository/recipes_repository.dart';

class DeleteRecipeSnackBar extends SnackBar {
  DeleteRecipeSnackBar({
    Key? key,
    required Recipe recipe,
    required VoidCallback onUndo,
  }) : super(
          key: key,
          content: Text(
            'Deleted ${recipe.title}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          duration: Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: onUndo,
          ),
        );
}
