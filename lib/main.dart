import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tu_wien_addressbook/models/tiss_login_manager.dart';
import 'package:tu_wien_addressbook/screens/login_screen.dart';
import 'package:tu_wien_addressbook/screens/person_search.dart';
import 'package:tu_wien_addressbook/screens/settings_screen.dart';
import 'package:tu_wien_addressbook/widgets/utils.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TU Addressbook',
      locale: Locale('en'),
      theme: ThemeData(
        brightness: Brightness.light,
        accentColor: Colors.indigo[400],
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.blueGrey[50],
        cardTheme: CardTheme(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)))),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.blue,
        primarySwatch: Colors.blue,
        //scaffoldBackgroundColor: Colors.blueGrey[50],
        cardTheme: CardTheme(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)))),
      ),
      debugShowCheckedModeBanner: false,
      home: MainPage(title: 'TU Addressbook'),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key? key, required this.title}) : super(key: key);

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
  Future<bool> _isLoggedIn = TissLoginManager().isLoggedIn();

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
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );

              setState(() {
                _isLoggedIn = TissLoginManager().isLoggedIn();
              });
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          //Padding(padding: EdgeInsets.only(top: 100)),
          Expanded(child: Container()),
          Center(
            child: Text("Search", style: Theme.of(context).textTheme.headline3),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              )),
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
                      "Students, Employees",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
          FutureBuilder(
            future: _isLoggedIn,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData || snapshot.data == true) return Text("");

              return RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: 'Login',
                      style: TextStyle(decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          print('WTF');
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                          print('NOW');
                          setState(() {
                            this._isLoggedIn = TissLoginManager().isLoggedIn();
                          });
                        }),
                  TextSpan(text: ' to find students.')
                ]),
              );
            },
          ),
          Expanded(
            child: Container(),
            flex: 2,
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: RichText(
              text: TextSpan(
                  style: TextStyle(
                      fontSize: Theme.of(context).textTheme.caption!.fontSize),
                  children: [
                    TextSpan(
                      text: "Made with ❤️ by ",
                    ),
                    TextSpan(
                        text: "flofriday",
                        style: TextStyle(decoration: TextDecoration.underline),
                        //style: TextStyle(decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchInBrowser("https://github.com/flofriday");
                          }),
                  ]),
            ),
          ),
        ]),
      ),
    );
  }
}
