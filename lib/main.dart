import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tu_wien_addressbook/screens/person_search.dart';
import 'package:tu_wien_addressbook/screens/settings_screen.dart';
import 'package:tu_wien_addressbook/models/person.dart';
import 'package:tu_wien_addressbook/screens/person_screen.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TU Addressbuch',
      theme: ThemeData(
        accentColor: Colors.blueGrey,
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.blueGrey[50],
      ),
      //theme: addressTheme,
      debugShowCheckedModeBanner: false,
      home: MainPage(title: 'TU Addressbuch'),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Person person;
  Future<SharedPreferences> futurePrefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          )
        ],
      ),
      body: HomeScreen(),
      /*body: Builder(builder: (BuildContext context) {
        if (person != null) {
          return PersonScreen(person);
        }

        // No person in memory so load one from shared preferences
        return FutureBuilder<SharedPreferences>(
            future: futurePrefs,
            builder: (BuildContext context,
                AsyncSnapshot<SharedPreferences> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text('Lade...'),
                );
              }

              SharedPreferences prefs = snapshot.data;

              try {
                this.person = Person.fromJson(
                    jsonDecode(prefs.getString("currentperson")));
                return PersonScreen(person);
              } catch (e) {
                print(e);
                return Center(
                    child: Text('Suche eine Person die du kennst...'));
              }
            });
      }),*/
      /*floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Person p =
              await showSearch(context: context, delegate: PersonSearch());
          if (p == null) return;
          setState(() {
            this.person = p;
          });
          SharedPreferences prefs = await futurePrefs;
          String json = jsonEncode(person.toJson());
          await prefs.setString("currentperson", json);
        },
        child: Icon(Icons.search),
      ),*/
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //Padding(padding: EdgeInsets.only(top: 100)),
          Expanded(child: Container()),
          Center(
            child: Text("Suche", style: Theme.of(context).textTheme.headline3),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: RaisedButton(
              color: Theme.of(context).cardColor,
              onPressed: () {
                showSearch(context: context, delegate: PersonSearch());
              },
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      size: 24,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Text(
                      "Studenten, Angetellte",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(),
            flex: 2,
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Text("Made with ❤️ by flofriday"),
          ),
        ],
      ),
    );
  }
}
