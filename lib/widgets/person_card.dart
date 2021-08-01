//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tu_wien_addressbook/models/person.dart';
import 'package:tu_wien_addressbook/screens/image_screen.dart';
import 'package:tu_wien_addressbook/widgets/person_avatar.dart';
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
                  SimpleTile(title: "Email", subtitle: person.email!),
                if (person.otherEmails != null &&
                    person.otherEmails!.isNotEmpty)
                  ...person.otherEmails!.map((email) => SimpleTile(
                        title: "Weitere Email",
                        subtitle: email,
                      )),
                if (person.phoneNumber != null)
                  SimpleTile(title: "Telefon", subtitle: person.phoneNumber!),
                if (person.phoneNumber != null || person.email != null)
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(children: [
                      if (person.phoneNumber != null)
                        Expanded(
                          child: TextButton(
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
                              launchPhone(person.phoneNumber!);
                            },
                          ),
                        ),
                      if (person.email != null)
                        Expanded(
                          child: TextButton(
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
                                  person.otherEmails!.isEmpty) {
                                launchEmail(person.email!, "",
                                    person.getNameWithTitles());
                                return;
                              }

                              // Open a bottom modal sheet to ask the user to select
                              // their prefered email.
                              String? choice = await showModalBottomSheet(
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
                                            title: Text(person.email!),
                                            subtitle: Text("Haupt Email"),
                                            onTap: () {
                                              Navigator.pop(
                                                  context, person.email);
                                            },
                                          ),
                                          ...person.otherEmails!.map(
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
                      Expanded(
                        child: TextButton(
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
              child: person.pictureUri == null
                  ? PersonAvatar(person, 100)
                  : GestureDetector(
                      child: Hero(
                        tag: 'personimage',
                        transitionOnUserGestures: true,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            person.getPictureUrl(),
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Image.network(
                                person.getPreviewPictureUrl(),
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                        flightShuttleBuilder: (flightContext, animation,
                            direction, fromContext, toContext) {
                          return AnimatedBuilder(
                              animation: animation,
                              builder:
                                  (BuildContext flightContext, Widget? child) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      100 * -(animation.value - 1)),
                                  child: Image.network(
                                    person.getPictureUrl(),
                                    fit: BoxFit.cover,
                                  ),
                                );
                              });
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return ImageScreen(
                                  person.getPictureUrl(), person.getName());
                            },
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
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
