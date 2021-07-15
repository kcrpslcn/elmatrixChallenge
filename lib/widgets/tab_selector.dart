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
          icon: _icon(tab),
          label: _label(tab),
        );
      }).toList(),
    );
  }

  Widget _icon(Tabs tab) {
    IconData icon;
    switch (tab) {
      case Tabs.stats:
        icon = Icons.show_chart;
        break;
      case Tabs.recipes:
        icon = Icons.list;
        break;
      case Tabs.info:
        icon = Icons.person;
        break;
      default:
        icon = Icons.error;
    }
    return Icon(icon);
  }

  String _label(Tabs tab) {
    String label;
    switch (tab) {
      case Tabs.stats:
        label = 'Stats';
        break;
      case Tabs.recipes:
        label = 'Recipes';
        break;
      case Tabs.info:
        label = 'Info';
        break;
      default:
        label = 'N/A';
    }
    return label;
  }
}
