import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tu_wien_addressbook/widgets/utils.dart';

class SettingsScreen extends StatelessWidget {
  static const EdgeInsets cardPadding =
      EdgeInsets.only(top: 10, left: 10, right: 10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Einstellungen"),
      ),
      body: Column(
        children: [
          Padding(
            padding: cardPadding,
            child: _LoginCard(),
          ),
          Padding(
            padding: cardPadding,
            child: _OpenSourceCard(),
          ),
        ],
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                              "Informationen über Studenten werden von TISS geschützt und können deswegen nur von eingeloggten Usern gesehen werden.")),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class _OpenSourceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: FaIcon(FontAwesomeIcons.osi),
          title: Text("Open Source"),
          subtitle: Text("made with ❤️ by flofriday"),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              text:
                  'Diese Application ist freie Software unter der MIT Lizens.\n\n',
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                    text: 'Warnung: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        'Obwohl die Daten von einer offiziellen TU Wien API kommen, ist diese App kein offizielles Angebot der TU Wien!'),
              ],
            ),
          ),
        ),
        ButtonBar(
          alignment: MainAxisAlignment.start,
          children: [
            FlatButton.icon(
                onPressed: () {
                  launchInBrowser(
                      "https://github.com/flofriday/TU_Wien_Addressbook");
                },
                icon: FaIcon(FontAwesomeIcons.github),
                label: Text("GitHub")),
            FlatButton.icon(
                onPressed: () {
                  launchInBrowser(
                      "https://github.com/flofriday/TU_Wien_Addressbook/blob/master/LICENSE");
                },
                icon: FaIcon(FontAwesomeIcons.balanceScale),
                label: Text("MIT Lizens"))
          ],
        )
      ],
    ));
  }
}
