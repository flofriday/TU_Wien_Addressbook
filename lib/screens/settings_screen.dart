import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Second Route"),
        ),
        body: Center(
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: 'Username',
                ),
                onChanged: (String value) async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
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
                onChanged: (String value) async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setString('password', value);
                  print('paswd: $value');
                },
              ),
              Center(
                child: Text("This settings are needed if you want to get " +
                    "information about students. However, at the moment this " +
                    "page doesn't show your username and password if you already set it"),
              )
            ],
          ),
        ));
  }
}
