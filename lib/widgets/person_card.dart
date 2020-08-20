import 'package:flutter/material.dart';
import 'package:tu_wien_addressbook/models/person.dart';
import 'package:tu_wien_addressbook/screens/image_screen.dart';
import 'package:tu_wien_addressbook/widgets/simple_tile.dart';
import 'package:tu_wien_addressbook/widgets/utils.dart';

class PersonInfoCard extends StatelessWidget {
  final Person person;

  PersonInfoCard(this.person);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(top: 100),
            width: double.infinity,
            child: Card(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 100)),
                SimpleTile(title: "Name", subtitle: person.getNameWithTitles()),
                SimpleTile(title: "Geschlecht", subtitle: person.getGender()),
                Builder(
                  builder: (BuildContext context) {
                    if (person.email == null) return Container();

                    return SimpleTile(title: "Email", subtitle: person.email);
                  },
                ),
                Builder(
                  builder: (BuildContext context) {
                    if (person.phoneNumber == null) return Container();

                    return SimpleTile(
                        title: "Telefon", subtitle: person.phoneNumber);
                  },
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Builder(builder: (BuildContext context) {
                      if (person.phoneNumber == null) return Container();

                      return FlatButton.icon(
                        icon: Icon(Icons.phone),
                        label: const Text('TEL'),
                        onPressed: () {
                          launchPhone(person.phoneNumber);
                        },
                      );
                    }),
                    Builder(builder: (BuildContext context) {
                      if (person.email == null) return Container();

                      return FlatButton.icon(
                        icon: Icon(Icons.email),
                        label: const Text('EMAIL'),
                        onPressed: () {
                          launchEmail(
                              person.email, "", person.getNameWithTitles());
                        },
                      );
                    }),
                    Builder(
                      builder: (BuildContext context) {
                        if (person.tissUri == null || person.employee == null)
                          return Container();

                        return FlatButton.icon(
                          icon: Icon(Icons.school),
                          label: Text('TISS'),
                          onPressed: () {
                            launchInBrowser(person.getTissUrl());
                          },
                        );
                      },
                    )
                  ],
                ),
              ],
            ))),
        Positioned(
          top: .0,
          left: .0,
          right: .0,
          child: Center(
            child: Material(
              borderRadius: BorderRadius.circular(100),
              elevation: 4,
              child: GestureDetector(
                child: person.getCircleAvatar(100),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageScreen(person.getPictureUrl(),
                          "${person.firstName} ${person.lastName}"),
                    ),
                  );
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
