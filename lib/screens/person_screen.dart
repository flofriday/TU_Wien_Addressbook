import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:tu_wien_addressbook/models/person.dart';
import 'package:tu_wien_addressbook/widgets/employee_card.dart';
import 'package:tu_wien_addressbook/widgets/student_card.dart';
import 'package:tu_wien_addressbook/widgets/person_card.dart';

class PersonScreen extends StatelessWidget {
  final Person person;

  const PersonScreen(this.person);

  static const EdgeInsets cardPadding =
      EdgeInsets.only(top: 10, left: 10, right: 10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${person.firstName} ${person.lastName}"),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share(person.getShareText());
            },
          ),
        ],
      ),
      body: Builder(builder: (BuildContext context) {
        // Calculate the number of cards shown
        int cards = 1;
        if (person.student != null) {
          cards++;
        }
        if (person.employee != null) {
          cards += person.employee!.length;
        }

        return ListView.builder(
          itemCount: cards + 1,
          itemBuilder: (BuildContext context, int index) {
            // Show the generell information about a person
            if (index == 0) {
              return Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 30),
                  child: PersonInfoCard(person));
            }

            // Show the student card if the person is a student
            if (person.student != null && index == 1) {
              return Padding(padding: cardPadding, child: StudentCard(person));
            }

            // Calculate which employee to show with this card
            int empployeeIndex = index - 1;
            if (person.student != null) empployeeIndex--;

            if (index == cards)
              return Padding(padding: EdgeInsets.only(bottom: 10));

            return Padding(
                padding: cardPadding,
                child: EmployeeCard(person.employee![empployeeIndex]));
          },
        );
      }),
    );
  }
}
