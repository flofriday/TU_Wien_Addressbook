import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Second Route"),
        ),
        body: Center(
            child: FutureBuilder<SharedPreferences>(
                future: _prefs, // a previously-obtained Future<String> or null
                builder: (BuildContext context,
                    AsyncSnapshot<SharedPreferences> snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: Text('Loading...'));

                  SharedPreferences prefs = snapshot.data;

                  return Column(
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
                          print('usr: $value');
                        },
                      ),
                      TextField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          labelText: 'Password',
                        ),
                        obscureText: true,
                        controller: TextEditingController()
                          ..text = prefs.getString('password'),
                        onChanged: (String value) async {
                          await prefs.setString('password', value);
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
                })));
  }
}
