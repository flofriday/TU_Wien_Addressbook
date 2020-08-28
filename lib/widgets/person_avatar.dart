import 'package:flutter/material.dart';
import 'package:tu_wien_addressbook/models/person.dart';

class PersonAvatar extends StatelessWidget {
  final Person _person;
  final double _radius;

  PersonAvatar(this._person, this._radius);

  @override
  Widget build(Object context) {
    if (_person.pictureUri != null) {
      return CircleAvatar(
        radius: _radius,
        backgroundImage: NetworkImage(_person.getPreviewPictureUrl()),
      );
    }

    return CircleAvatar(
      radius: _radius,
      child: Text(
        _person.firstName[0] + _person.lastName[0],
        style: TextStyle(fontSize: _radius * 0.6),
      ),
    );
  }
}
