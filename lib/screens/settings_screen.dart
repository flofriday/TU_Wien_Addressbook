import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Einstellungen"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: FutureBuilder<SharedPreferences>(
                future: _prefs, // a previously-obtained Future<String> or null
                builder: (BuildContext context,
                    AsyncSnapshot<SharedPreferences> snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: Text('Loading...'));

                  SharedPreferences prefs = snapshot.data;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          labelText: 'Username',
                        ),
                        controller: TextEditingController()
                          ..text = prefs.getString('username'),
                        onChanged: (String value) async {
                          await prefs.setString('username', value);
                          await prefs.remove('tisscookie');
                          await prefs.remove('tisscookietime');
                          print('usr: $value');
                        },
                      ),
                      TextField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.lock),
                          labelText: 'Passwort',
                        ),
                        obscureText: true,
                        controller: TextEditingController()
                          ..text = prefs.getString('password'),
                        onChanged: (String value) async {
                          await prefs.setString('password', value);
                          await prefs.remove('tisscookie');
                          await prefs.remove('tisscookietime');
                          print('paswd: $value');
                        },
                      ),
                      Center(
                        child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                                "This settings are needed if you want to get " +
                                    "information about students.")),
                      )
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
