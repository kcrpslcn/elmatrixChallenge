import 'package:flutter/material.dart';
import 'package:recipes_repository/recipes_repository.dart';

class RecipeFailureSnackBar extends SnackBar {
  RecipeFailureSnackBar({
    Key? key,
    required List<RecipeFailure> failures,
    required VoidCallback onShow,
  }) : super(
          key: key,
          content: Text(
            '${failures.length} item${failures.length > 1 ? 's' : ''} with an error state',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          duration: Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Show',
            onPressed: onShow,
          ),
        );
}
