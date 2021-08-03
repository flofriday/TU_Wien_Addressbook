import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginCard extends StatelessWidget {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(
          leading: Icon(Icons.school),
          title: Text("TU Wien Login"),
          subtitle: Text("(optional)"),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: FutureBuilder<SharedPreferences>(
              future: _prefs, // a previously-obtained Future<String> or null
              builder: (BuildContext context,
                  AsyncSnapshot<SharedPreferences> snapshot) {
                if (!snapshot.hasData) return Center(child: Text('Loading...'));

                SharedPreferences? prefs = snapshot.data;

                return Column(mainAxisSize: MainAxisSize.min, children: [
                  TextField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: 'Username',
                    ),
                    controller: TextEditingController()
                      ..text = prefs!.getString('username')!,
                    onChanged: (String value) async {
                      await prefs.setString('username', value);
                      await prefs.remove('tisscookie');
                      await prefs.remove('tisscookietime');
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.lock),
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    controller: TextEditingController()
                      ..text = prefs.getString('password')!,
                    onChanged: (String value) async {
                      await prefs.setString('password', value);
                      await prefs.remove('tisscookie');
                      await prefs.remove('tisscookietime');
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text("TISS protects students privacy, therefore you "
                        "need to be logged in to find them.\n\n"
                        "Your credentials are only saved locally on this "
                        "device and are only send to TISS to authenticate "
                        "you"),
                  ),
                ]);
              }),
        ),
      ]),
    );
  }
}
