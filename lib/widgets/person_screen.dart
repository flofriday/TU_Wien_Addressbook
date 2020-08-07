import 'package:flutter/material.dart';
import 'package:tu_wien_addressbook/models/person.dart';
import 'package:tu_wien_addressbook/widgets/utils.dart';

class PersonScreen extends StatelessWidget {
  final Person person;

  const PersonScreen(this.person);

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

    return Container(
      margin: EdgeInsets.all(10),
      constraints: BoxConstraints.expand(),
      child: ListView.builder(
        itemCount: cards,
        itemBuilder: (BuildContext context, int index) {
          // Show the generell information about a person
          if (index == 0) {
            return _PersonInfoCard(person);
          }

          // Show the student card if the person is a student
          if (person.student != null && index == 1) {
            return Padding(
                padding: EdgeInsets.only(top: 10), child: Text('Studentcard'));
          }

          // Calculate which employee to show with this card
          int empployeeIndex = index - 1;
          if (person.student != null) empployeeIndex--;

          return Padding(
              padding: EdgeInsets.only(top: 10),
              child: _EmployeeCard(person.employee[empployeeIndex]));
        },
      ),
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
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: SelectableText(person.getNameWithTitles()),
                        ),
                        Builder(builder: (BuildContext context) {
                          if (person.email == null) return Container();

                          return Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: SelectableText(
                              person.email,
                            ),
                          );
                        }),
                        Builder(builder: (BuildContext context) {
                          if (person.phoneNumber == null) return Container();

                          return Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: SelectableText(person.phoneNumber),
                          );
                        }),
                      ],
                    )),
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
                    FlatButton.icon(
                      icon: Icon(Icons.school),
                      label: Text('TISS'),
                      onPressed: () {
                        launchInBrowser(person.getTissUrl());
                      },
                    ),
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
  Employee employee;

  _EmployeeCard(this.employee);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(0),
            child: ListTile(
              title: Text(employee.function),
              subtitle: Text(employee.orgRef.name),
            ))
      ],
    ));
  }
}
