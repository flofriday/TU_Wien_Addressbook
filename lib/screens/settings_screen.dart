import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tu_wien_addressbook/models/suggestion_manager.dart';
import 'package:tu_wien_addressbook/models/tiss_login_manager.dart';
import 'package:tu_wien_addressbook/widgets/utils.dart';

import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<PackageInfo> _packageInfo = PackageInfo.fromPlatform();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(
        children: [
          Container(
            color: Theme.of(context).cardColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Account"),
                  subtitle: FutureBuilder(
                      future: TissLoginManager().isLoggedIn(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) return Text("");

                        if (snapshot.data == true) {
                          return FutureBuilder(
                              future: SharedPreferences.getInstance(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (!snapshot.hasData) return Text("");

                                return Text(
                                    "Logged in as ${snapshot.data.getString('username')}");
                              });
                        }

                        return Text("Log in now");
                      }),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                    setState(() {});
                  },
                ),
                ListTile(
                  leading: Icon(Icons.clear_all),
                  title: Text("Clear History"),
                  subtitle: Text("Clear all search suggestions"),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Are you sure?'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: const <Widget>[
                                  Text(
                                      'This will irreversable delete all search sugestions.'),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.red)),
                                child: const Text('Delete'),
                                onPressed: () async {
                                  await SuggestionManager().clear();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        });
                  },
                ),
                ListTile(
                  leading: Icon(Icons.question_answer),
                  title: Text("FAQ"),
                  subtitle: Text("Frequently asked questions"),
                  trailing: Icon(Icons.open_in_new),
                  onTap: () {
                    launchInBrowser(
                        "https://github.com/flofriday/TU_Wien_Addressbook#frequently-asked-question");
                  },
                ),
                ListTile(
                  leading: Icon(Icons.public),
                  title: Text("GitHub"),
                  subtitle: Text("Sourcecode Repository"),
                  trailing: Icon(Icons.open_in_new),
                  onTap: () {
                    launchInBrowser(
                        "https://github.com/flofriday/TU_Wien_Addressbook");
                  },
                ),
                ListTile(
                    leading: Icon(Icons.gavel),
                    title: Text("MIT License"),
                    subtitle: Text("This is open-source software"),
                    trailing: Icon(Icons.open_in_new),
                    onTap: () {
                      launchInBrowser(
                          "https://github.com/flofriday/TU_Wien_Addressbook/blob/master/LICENSE");
                    }),
                ListTile(
                  leading: Icon(Icons.description),
                  title: Text("Third party licenses"),
                  subtitle: Text("Frameworks and libraries used"),
                  onTap: () async {
                    PackageInfo packageInfo = await _packageInfo;
                    showLicensePage(
                      context: context,
                      applicationName: packageInfo.appName,
                      applicationVersion: packageInfo.version,
                      applicationIcon: Image(
                        image: AssetImage('logo_small.png'),
                        height: 100,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Center(
            child: FutureBuilder(
                future: PackageInfo.fromPlatform(),
                builder: (BuildContext context,
                    AsyncSnapshot<PackageInfo> snapshot) {
                  if (!snapshot.hasData) return Text("zz");

                  String build = "debug";
                  if (kReleaseMode) build = "release";

                  return TextButton(
                    child: Text(
                      "Version ${snapshot.data!.version} $build build",
                      style: Theme.of(context).textTheme.caption,
                    ),
                    onPressed: () {
                      // This is just for the animation to hint that there
                      // is something
                    },
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('🐮 Mooooooo!'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: const <Widget>[
                                  Text(
                                      'Oh no!\nYou found on of my eastereggs, how emberassing. 🙈\n\nOk you can keep it, but please don\'t tell the other about this.'),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('I will be quiet.'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
