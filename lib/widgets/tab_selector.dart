import 'package:elmatrix_niclas/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TabSelector extends StatelessWidget {
  final Tabs activeTab;
  final Function(Tabs) onTabSelected;

  TabSelector({
    Key? key,
    required this.activeTab,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: Tabs.values.indexOf(activeTab),
      onTap: (index) => onTabSelected(Tabs.values[index]),
      items: Tabs.values.map((tab) {
        return BottomNavigationBarItem(
          icon: Icon(
            tab == Tabs.recipes ? Icons.list : Icons.show_chart,
          ),
          label: tab == Tabs.stats ? 'Stats' : 'Recipes',
        );
      }).toList(),
    );
  }
}
