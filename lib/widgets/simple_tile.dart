import 'package:flutter/material.dart';

class SimpleTile extends StatelessWidget {
  final String title;
  final String subtitle;

  SimpleTile({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(title, style: theme.textTheme.subtitle1),
          SelectableText(
            subtitle,
            style: theme.textTheme.bodyText2!
                .copyWith(color: theme.textTheme.caption!.color),
          ),
        ],
      ),
    );
  }
}
