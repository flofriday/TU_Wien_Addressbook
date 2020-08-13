import 'package:flutter/material.dart';

class SimpleTile extends StatelessWidget {
  final String title;
  final String subtitle;

  SimpleTile({this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: SelectableText(this.title),
      subtitle: SelectableText(this.subtitle),
    );
  }
}
