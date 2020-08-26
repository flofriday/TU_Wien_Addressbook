import 'package:flutter/material.dart';
import 'package:tu_wien_addressbook/models/person.dart';
import 'package:tu_wien_addressbook/widgets/simple_tile.dart';
import 'package:tu_wien_addressbook/widgets/utils.dart';

class EmployeeCard extends StatelessWidget {
  final Employee employee;

  EmployeeCard(this.employee);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SimpleTile(
          title: employee.function,
          subtitle: employee.orgRef.name,
        ),
        if (employee.room != null)
          SimpleTile(
            title: "Raum " + employee.room.roomCode,
            subtitle: employee.room.address.toString(),
          ),
        Builder(builder: (BuildContext context) {
          if (employee.phoneNumbers == null) return Container();

          int numPhones = employee.phoneNumbers.length;

          List<Widget> widgets = List();
          for (int i = 0; i < numPhones; i++) {
            String title = "Telefon";
            if (numPhones > 1) {
              title += " ${i + 1}";
            }
            widgets.add(
                SimpleTile(title: title, subtitle: employee.phoneNumbers[i]));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
            widgets.add(
                SimpleTile(title: title, subtitle: employee.websites[i].uri));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widgets,
          );
        }),
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            if (employee.phoneNumbers != null)
              FlatButton.icon(
                icon: Icon(Icons.phone),
                label: const Text('TEL'),
                onPressed: () async {
                  // Launch the phone app if there is just one numner
                  if (employee.phoneNumbers.length == 1) {
                    launchPhone(employee.phoneNumbers[0]);
                    return;
                  }

                  // Open a bottom modal sheet and ask the user which website
                  // they wanna see
                  String choice = await showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      context: context,
                      builder: (context) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          //color: Theme.of(context).cardColor,
                          child: SafeArea(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  title: Text("Wähle eine Nummer",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                ),
                                ...employee.phoneNumbers.map(
                                  (phone) => ListTile(
                                    title: Text(phone),
                                    onTap: () {
                                      Navigator.pop(context, phone);
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      });

                  // Do nothing if the user didn't selected anything
                  if (choice == null) return;

                  // Launch the phone
                  launchPhone(choice);
                },
              ),
            if (employee.websites != null)
              FlatButton.icon(
                icon: Icon(Icons.open_in_browser),
                label: const Text('WEB'),
                onPressed: () async {
                  // Launch the phone app if there is just one numner
                  if (employee.websites.length == 1) {
                    launchInBrowser(employee.websites[0].uri);
                    return;
                  }

                  // Open a bottom modal sheet and ask the user which website
                  // they wanna see
                  String choice = await showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      context: context,
                      builder: (context) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          //color: Theme.of(context).cardColor,
                          child: SafeArea(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  title: Text("Wähle eine Webseite",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                ),
                                ...employee.websites.map(
                                  (website) => ListTile(
                                    title: Text(website.uri),
                                    onTap: () {
                                      Navigator.pop(context, website.uri);
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      });

                  // Do nothing if the user didn't selected anything
                  if (choice == null) return;

                  // Launch the phone
                  launchInBrowser(choice);
                },
              ),
            if (employee.room != null)
              FlatButton.icon(
                icon: Icon(Icons.map),
                label: const Text('KARTE'),
                onPressed: () {
                  launchInBrowser(employee.room.getMapUrl());
                },
              ),
            if (employee.orgRef != null && employee.orgRef.tissId != null)
              FlatButton.icon(
                icon: Icon(Icons.school),
                label: Text('TISS'),
                onPressed: () {
                  launchInBrowser(employee.orgRef.getTissUrl());
                },
              ),
          ],
        ),
      ],
    ));
  }
}
