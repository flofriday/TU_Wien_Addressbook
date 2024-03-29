import 'package:flutter/material.dart';
import 'package:tu_wien_addressbook/models/person.dart';
import 'package:tu_wien_addressbook/widgets/simple_tile.dart';

class StudentCard extends StatelessWidget {
  final Person person;

  StudentCard(this.person);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SimpleTile(
              title: "Student",
              subtitle: "since ${person.student!.getMatriculationYear()}",
            ),
            SimpleTile(
              title: "Matriculation number",
              subtitle: person.student!.matriculationNumber,
            ),
          ],
        ),
      ),
    );
  }
}
