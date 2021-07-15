import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Niclas Prock',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              '(Junior) Mobile Developer Flutter',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'niclasprock@gmail.com',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              '0177 / 758 90 57',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ],
      ),
    );
  }
}
