import 'package:flutter/material.dart';
import 'package:tu_wien_addressbook/models/person.dart';

class PersonEntry extends StatelessWidget {
  final Person person;
  final GestureTapCallback onTap;

  const PersonEntry(this.person, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      isThreeLine: false,
      leading: Hero(tag: person.tissUri, child: person.getCircleAvatar(20)),
      title: Text(
        "${person.firstName} ${person.lastName}",
      ),
      subtitle: Text(
        person.getShortDescription(),
        maxLines: 1,
      ),
    );
  }
}
