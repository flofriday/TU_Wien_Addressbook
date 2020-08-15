import 'package:flutter/material.dart';
import 'package:tu_wien_addressbook/models/person.dart';

class PersonEntry extends StatelessWidget {
  final Person person;

  const PersonEntry(this.person);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: false,
      leading: person.getCircleAvatar(20),
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
