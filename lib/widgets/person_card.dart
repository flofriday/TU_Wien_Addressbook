import 'package:flutter/material.dart';
import 'package:tu_wien_adressbook/models/person.dart';

class PersonCard extends StatelessWidget {
  final Person person;

  const PersonCard(this.person);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      leading: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
                fit: BoxFit.cover,
                image: new NetworkImage(person.getPictureUrl()))),
      ),
      title: Text(
        "${person.firstName} ${person.lastName}",
      ),
      subtitle: Text(person.getShortDescription()),
    ));
  }
}

class PersonScreen extends StatelessWidget {
  final Person person;

  const PersonScreen(this.person);

  @override
  Widget build(BuildContext context) {
    //return Center(child: Text(person.firstName));
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                  fit: BoxFit.cover,
                  image: new NetworkImage(person.getPictureUrl()))),
        ),
        Text(person.getNameWithTitles()),
        Text(person.getShortDescription()),
        Text(person.email),
      ],
    ));
  }
}
