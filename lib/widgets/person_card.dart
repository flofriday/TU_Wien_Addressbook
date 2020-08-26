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
                if (person.email != null)
                  SimpleTile(title: "Email", subtitle: person.email),
                if (person.otherEmails != null && person.otherEmails.isNotEmpty)
                  ...person.otherEmails.map((email) => SimpleTile(
                        title: "Weitere Email",
                        subtitle: email,
                      )),
                if (person.phoneNumber != null)
                  SimpleTile(title: "Telefon", subtitle: person.phoneNumber),
                if (person.phoneNumber != null ||
                    person.email != null ||
                    person.tissUri != null)
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(children: [
                      if (person.phoneNumber != null)
                        Expanded(
                          child: FlatButton(
                            textColor: Theme.of(context).accentColor,
                            child: Column(
                              children: [
                                Icon(Icons.phone),
                                Text(
                                  "Telefon",
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                            onPressed: () {
                              launchPhone(person.phoneNumber);
                            },
                          ),
                        ),
                      if (person.email != null)
                        Expanded(
                          child: FlatButton(
                            textColor: Theme.of(context).accentColor,
                            child: Column(
                              children: [
                                Icon(Icons.mail),
                                Text(
                                  "Email",
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                            onPressed: () async {
                              // Open the email app if there is only one email
                              if (person.otherEmails == null ||
                                  person.otherEmails.isEmpty) {
                                launchEmail(person.email, "",
                                    person.getNameWithTitles());
                                return;
                              }

                              // Open a bottom modal sheet to ask the user to select
                              // their prefered email.
                              String choice = await showModalBottomSheet(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10)),
                                  ),
                                  context: context,
                                  builder: (context) {
                                    return SafeArea(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            title: Text("Wähle eine Email",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6),
                                          ),
                                          ListTile(
                                            title: Text(person.email),
                                            subtitle: Text("Haupt Email"),
                                            onTap: () {
                                              Navigator.pop(
                                                  context, person.email);
                                            },
                                          ),
                                          ...person.otherEmails.map(
                                            (email) => ListTile(
                                              title: Text(email),
                                              subtitle: Text("Weitere Email"),
                                              onTap: () {
                                                Navigator.pop(context, email);
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  });

                              // Do nothing if the user didn't selected anything
                              if (choice == null) return;

                              // Launch the phone
                              launchEmail(
                                  choice, "", person.getNameWithTitles());
                            },
                          ),
                        ),
                      if (person.tissUri != null)
                        Expanded(
                          child: FlatButton(
                            textColor: Theme.of(context).accentColor,
                            child: Column(
                              children: [
                                Icon(Icons.school),
                                Text(
                                  "TISS",
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                            onPressed: () {
                              launchInBrowser(person.getTissUrl());
                            },
                          ),
                        ),
                    ]),
                  ),
              ],
            ),
          ),
        ),
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
