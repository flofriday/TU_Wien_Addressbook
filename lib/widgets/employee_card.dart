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
            Padding(
              padding: EdgeInsets.only(top: 8),
            ),
            SimpleTile(
              title: employee.function,
              subtitle: employee.orgRef.name,
            ),
            if (employee.room != null)
              SimpleTile(
                title: "Raum " + employee.room!.roomCode,
                subtitle: employee.room!.address.toString(),
              ),
            Builder(builder: (BuildContext context) {
              if (employee.phoneNumbers == null) return Container();

              int numPhones = employee.phoneNumbers!.length;

              List<Widget> widgets = [];
              for (int i = 0; i < numPhones; i++) {
                String title = "Telefon";
                if (numPhones > 1) {
                  title += " ${i + 1}";
                }
                widgets.add(SimpleTile(
                    title: title, subtitle: employee.phoneNumbers![i]));
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widgets,
              );
            }),
            Builder(builder: (BuildContext context) {
              if (employee.websites == null) return Container();

              int numWebsites = employee.websites!.length;

              List<Widget> widgets = [];
              for (int i = 0; i < numWebsites; i++) {
                String title = "Webseite";
                if (numWebsites > 1) {
                  title += " ${i + 1}";
                }
                widgets.add(SimpleTile(
                    title: title, subtitle: employee.websites![i].uri));
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widgets,
              );
            }),
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(children: [
                if (employee.phoneNumbers != null)
                  Expanded(
                    child: TextButton(
                      child: Column(
                        children: [
                          Icon(Icons.phone),
                          Text(
                            "Telefon",
                            style: Theme.of(context).textTheme.caption,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      onPressed: () async {
                        // Launch the phone app if there is just one numner
                        if (employee.phoneNumbers!.length == 1) {
                          launchPhone(employee.phoneNumbers![0]);
                          return;
                        }

                        // Open a bottom modal sheet and ask the user which website
                        // they wanna see
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
                                        title: Text("Wähle eine Nummer",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6),
                                      ),
                                      ...employee.phoneNumbers!.map(
                                        (phone) => ListTile(
                                          title: Text(phone),
                                          onTap: () {
                                            Navigator.pop(context, phone);
                                          },
                                        ),
                                      )
                                    ]),
                              );
                            });

                        // Do nothing if the user didn't selected anything
                        if (choice == null) return;

                        // Launch the phone
                        launchPhone(choice);
                      },
                    ),
                  ),
                if (employee.websites != null)
                  Expanded(
                    child: TextButton(
                      child: Column(
                        children: [
                          Icon(Icons.public),
                          Text(
                            "Webseite",
                            style: Theme.of(context).textTheme.caption,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      onPressed: () async {
                        // Launch the phone app if there is just one numner
                        if (employee.websites!.length == 1) {
                          launchInBrowser(employee.websites![0].uri);
                          return;
                        }

                        // Open a bottom modal sheet and ask the user which website
                        // they wanna see
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
                                      title: Text("Wähle eine Webseite",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                    ),
                                    ...employee.websites!.map(
                                      (website) => ListTile(
                                        title: Text(website.uri),
                                        onTap: () {
                                          Navigator.pop(context, website.uri);
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
                        launchInBrowser(choice);
                      },
                    ),
                  ),
                if (employee.room != null)
                  Expanded(
                    child: TextButton(
                      child: Column(
                        children: [
                          Icon(Icons.map),
                          Text(
                            "Karte",
                            style: Theme.of(context).textTheme.caption,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      onPressed: () {
                        launchInBrowser(employee.room!.getMapUrl());
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    onPressed: () {
                      launchInBrowser(employee.orgRef.getTissUrl());
                    },
                  ),
                ),
              ]),
            ),
          ]),
    );
  }
}
