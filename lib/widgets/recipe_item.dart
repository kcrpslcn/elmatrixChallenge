import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:recipes_repository/recipes_repository.dart';

class RecipeItem extends StatelessWidget {
  final DismissDirectionCallback onDismissed;
  final GestureTapCallback onTap;
  final Recipe recipe;

  RecipeItem({
    Key? key,
    required this.onDismissed,
    required this.onTap,
    required this.recipe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dismissible(
      key: Key('__recipe_item_${recipe.id}'),
      onDismissed: onDismissed,
      child: ListTile(
        onTap: onTap,
        title: Container(
          width: MediaQuery.of(context).size.width,
          child: Text(
            recipe.title,
            style: theme.textTheme.headline6,
          ),
        ),
        subtitle: recipe.subtitle != null && recipe.subtitle!.isNotEmpty
            ? Text(
                recipe.subtitle!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.subtitle1,
              )
            : null,
      ),
    );
  }
}
