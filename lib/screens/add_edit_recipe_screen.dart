import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipes_repository/recipes_repository.dart';

typedef OnSaveCallback = Function(
    String title, String? subtitle, IngredientList ingredients, StepList steps);

class AddEditRecipeScreen extends StatefulWidget {
  final bool isEditing;
  final OnSaveCallback onSave;
  final Recipe? recipe;

  AddEditRecipeScreen({
    Key? key,
    required this.onSave,
    required this.isEditing,
    this.recipe,
  }) : super(key: key);

  @override
  _AddEditRecipeScreenState createState() => _AddEditRecipeScreenState();
}

class _AddEditRecipeScreenState extends State<AddEditRecipeScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _title;
  String? _subtitle;

  late IngredientList _ingredients;
  late StepList _steps;

  bool get isEditing => widget.isEditing;

  @override
  void initState() {
    _ingredients = widget.recipe?.ingredients ?? IngredientList([]);
    _steps = widget.recipe?.steps ?? StepList([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Recipe' : 'Add Recipe',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: isEditing ? widget.recipe?.title : '',
                autofocus: !isEditing,
                style: textTheme.headline5,
                decoration: InputDecoration(
                  hintText: 'Recipe name',
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter some text';
                  }
                },
                onSaved: (value) => _title = value,
              ),
              TextFormField(
                initialValue: isEditing ? widget.recipe?.subtitle ?? '' : '',
                maxLines: 3,
                style: textTheme.subtitle1,
                decoration: InputDecoration(
                  hintText: 'Subtitle',
                ),
                onSaved: (value) => _subtitle = value,
              ),
              Container(
                height: 24,
              ),
              ElevatedButton(
                  onPressed: () async {
                    final ingredient = await addEditIngredientDialog();
                    if (ingredient != null) {
                      _ingredients.addIngredient(ingredient);
                      setState(() {});
                    }
                  },
                  child: const Text('Add Ingredient')),
              Padding(
                padding: EdgeInsets.all(12),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _ingredients.ingredients?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      final ingredient = _ingredients.ingredients?[index];
                      return Dismissible(
                        key: Key('_ingredient_$index'),
                        onDismissed: (_) {
                          if (ingredient != null) {
                            _ingredients.removeIngredient(ingredient);
                          }
                        },
                        child: GestureDetector(
                          onTap: () async {
                            final target =
                                await addEditIngredientDialog(true, ingredient);
                            if (ingredient != null && target != null)
                              _ingredients.updateIngredient(ingredient, target);
                          },
                          child: Text(
                            '${ingredient.toString()}',
                          ),
                        ),
                      );
                    }),
              ),
              ElevatedButton(
                  onPressed: () async {
                    final step = await addEditStepDialog();
                    if (step != null) {
                      _steps.addStep(step);
                      setState(() {});
                    }
                  },
                  child: const Text('Add Step')),
              Padding(
                padding: EdgeInsets.all(12),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _steps.steps?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      final step = _steps.steps?[index];
                      return Dismissible(
                        key: Key('_step_$index'),
                        onDismissed: (_) {
                          if (step != null) {
                            _steps.removeStep(step);
                          }
                        },
                        child: TextFormField(
                          initialValue: '${step?.name ?? ''}',
                          onChanged: (value) => {
                            if (step != null)
                              _steps.updateStep(step, StepModel(value)),
                          },
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: isEditing ? 'Save changes' : 'Add Recipe',
        child: Icon(isEditing
            ? Icons.check
            : formIsValid()
                ? Icons.add
                : null),
        backgroundColor: isEditing || formIsValid() ? Colors.blue : Colors.red,
        onPressed: () {
          final currentState = _formKey.currentState;
          if (currentState != null && currentState.validate()) {
            currentState.save();
            if (formIsValid()) {
              widget.onSave(_title ?? '', _subtitle, _ingredients, _steps);
              Navigator.pop(context);
            }
          }
        },
      ),
    );
  }

  bool formIsValid() {
    return _ingredients.valid && _steps.valid;
  }

  Future<Ingredient?> addEditIngredientDialog(
      [isEditing = false, Ingredient? ingredient]) async {
    return await showDialog<Ingredient?>(
        context: context,
        builder: (BuildContext context) {
          String name = ingredient?.name ?? '';
          int amount = ingredient?.amount ?? 0;
          String measurement = ingredient?.measurement ?? '';
          return SimpleDialog(
            title: Text(isEditing ? 'Edit Ingredient' : 'Add Ingredient'),
            children: <Widget>[
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(
                  hintText: 'Name',
                ),
                onChanged: (value) => name = value,
              ),
              TextFormField(
                initialValue: measurement,
                decoration: InputDecoration(
                  hintText: 'Measurement',
                ),
                onChanged: (value) => measurement = value,
              ),
              TextFormField(
                initialValue: amount == 0 ? null : amount.toString(),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: 'Amount',
                ),
                onChanged: (value) => amount = int.parse(value),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Ingredient(name, amount, measurement));
                },
                child: const Text('Confirm'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, null);
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        });
  }

  Future<StepModel?> addEditStepDialog(
      [isEditing = false, StepModel? step]) async {
    return await showDialog<StepModel?>(
        context: context,
        builder: (BuildContext context) {
          String name = step?.name ?? '';
          return SimpleDialog(
            title: Text(isEditing ? 'Edit Step' : 'Add Step'),
            children: <Widget>[
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(
                  hintText: 'Name',
                ),
                onChanged: (value) => name = value,
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, StepModel(name));
                },
                child: const Text('Confirm'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, null);
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        });
  }
}
