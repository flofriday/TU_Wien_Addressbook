import 'package:flutter/material.dart';
import 'package:tu_wien_addressbook/models/person.dart';
import 'package:tu_wien_addressbook/widgets/utils.dart';

class PersonScreen extends StatelessWidget {
  final Person person;

  const PersonScreen(this.person);

  static const EdgeInsets cardPadding =
      EdgeInsets.only(top: 16, left: 16, right: 16);

  @override
  Widget build(BuildContext context) {
    // Calculate the number of cards shown
    int cards = 1;
    if (person.student != null) {
      cards++;
    }
    if (person.employee != null) {
      cards += person.employee.length;
    }

    return ListView.builder(
      itemCount: cards + 1,
      itemBuilder: (BuildContext context, int index) {
        // Show the generell information about a person
        if (index == 0) {
          return Padding(padding: cardPadding, child: _PersonInfoCard(person));
        }

        // Show the student card if the person is a student
        if (person.student != null && index == 1) {
          return Padding(padding: cardPadding, child: _StudentCard(person));
        }

        // Add a padding at the end so that the floating action button
        // doesn't get in the way of the last card
        if (index == cards) return Padding(padding: EdgeInsets.only(top: 80));

        // Calculate which employee to show with this card
        int empployeeIndex = index - 1;
        if (person.student != null) empployeeIndex--;

        return Padding(
            padding: cardPadding,
            child: _EmployeeCard(person.employee[empployeeIndex]));
      },
    );
  }
}

class _PersonInfoCard extends StatelessWidget {
  final Person person;

  _PersonInfoCard(this.person);

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
                _Info(title: "Name", subtitle: person.getNameWithTitles()),
                _Info(title: "Geschlecht", subtitle: person.getGender()),
                Builder(
                  builder: (BuildContext context) {
                    if (person.email == null) return Container();

                    return _Info(title: "Email", subtitle: person.email);
                  },
                ),
                Builder(
                  builder: (BuildContext context) {
                    if (person.phoneNumber == null) return Container();

                    return _Info(
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
                        label: const Text('CALL'),
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
          child: Center(child: person.getCircleAvatar(100)),
        )
      ],
    );
  }
}

class _EmployeeCard extends StatelessWidget {
  final Employee employee;

  _EmployeeCard(this.employee);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _Info(
          title: employee.function,
          subtitle: employee.orgRef.name,
        ),
        Builder(builder: (BuildContext context) {
          if (employee.room == null) return Container();

          return _Info(
              title: "Raum " + employee.room.roomCode,
              subtitle: employee.room.address.toString());
        }),
        Builder(builder: (BuildContext context) {
          if (employee.phoneNumbers == null) return Container();

          int numPhones = employee.phoneNumbers.length;

          List<Widget> widgets = List();
          for (int i = 0; i < numPhones; i++) {
            String title = "Telefon";
            if (numPhones > 1) {
              title += " ${i + 1}";
            }
            widgets
                .add(_Info(title: title, subtitle: employee.phoneNumbers[i]));
          }

          return Column(
            children: widgets,
          );
        }),
        Builder(builder: (BuildContext context) {
          if (employee.websites == null) return Container();

          int numWebsites = employee.websites.length;

          List<Widget> widgets = List();
          for (int i = 0; i < numWebsites; i++) {
            String title = "Webseite";
            if (numWebsites > 1) {
              title += " ${i + 1}";
            }
            widgets
                .add(_Info(title: title, subtitle: employee.websites[i].uri));
          }

          return Column(
            children: widgets,
          );
        }),
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            Builder(builder: (BuildContext context) {
              if (employee.phoneNumbers == null) return Container();

              // TODO: also display the button if there is more than one phone
              // and open a popup if clicked
              if (employee.phoneNumbers.length != 1) return Container();

              return FlatButton.icon(
                icon: Icon(Icons.phone),
                label: const Text('CALL'),
                onPressed: () {
                  launchPhone(employee.phoneNumbers[0]);
                },
              );
            }),
            Builder(builder: (BuildContext context) {
              if (employee.websites == null) return Container();

              // TODO: also display the button if there is more than one website
              // and open a popup if clicked
              if (employee.websites.length != 1) return Container();

              return FlatButton.icon(
                icon: Icon(Icons.open_in_browser),
                label: const Text('WEB'),
                onPressed: () {
                  launchInBrowser(employee.websites[0].uri);
                },
              );
            }),
            Builder(builder: (BuildContext context) {
              if (employee.room == null) return Container();

              return FlatButton.icon(
                icon: Icon(Icons.map),
                label: const Text('KARTE'),
                onPressed: () {
                  launchInBrowser(employee.room.getMapUrl());
                },
              );
            }),
            Builder(
              builder: (BuildContext context) {
                if (employee.orgRef == null || employee.orgRef.tissId == null)
                  return Container();

                return FlatButton.icon(
                  icon: Icon(Icons.school),
                  label: Text('TISS'),
                  onPressed: () {
                    launchInBrowser(employee.orgRef.getTissUrl());
                  },
                );
              },
            ),
          ],
        ),
      ],
    ));
  }
}

class _StudentCard extends StatelessWidget {
  final Person person;

  _StudentCard(this.person);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _Info(
          title: person.gender == "W" ? "Studentin" : "Student",
          subtitle: "seit ${person.student.getMatriculationYear()}",
        ),
        _Info(
          title: "Matrikelnummer",
          subtitle: person.student.matriculationNumber,
        ),
      ],
    ));
  }
}

class _Info extends StatelessWidget {
  final String title;
  final String subtitle;

  _Info({this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: SelectableText(this.title),
      subtitle: SelectableText(this.subtitle),
    );
  }
}
