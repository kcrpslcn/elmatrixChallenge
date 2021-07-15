import 'package:elmatrix_niclas/blocs/tab/tab_bloc.dart';
import 'package:elmatrix_niclas/models/models.dart';
import 'package:elmatrix_niclas/widgets/info.dart';
import 'package:elmatrix_niclas/widgets/recipes.dart';
import 'package:elmatrix_niclas/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabBloc, Tabs>(
      builder: (context, activeTab) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Elmatrix Recipes'),
          ),
          body: _body(activeTab),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/addRecipe');
            },
            child: Icon(Icons.add),
            tooltip: 'Add Recipe',
          ),
          bottomNavigationBar: TabSelector(
            activeTab: activeTab,
            onTabSelected: (tab) => context.read<TabBloc>().add(UpdateTab(tab)),
          ),
        );
      },
    );
  }

  Widget _body(Tabs activeTab) {
    switch (activeTab) {
      case Tabs.recipes:
        return Recipes();
      case Tabs.stats:
        return Stats();
      case Tabs.info:
        return Info();
      default:
        return Container();
    }
  }
}
