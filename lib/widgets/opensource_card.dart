import 'package:flutter/material.dart';
import 'package:tu_wien_addressbook/widgets/utils.dart';

class OpenSourceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.public),
            title: Text("Open Source"),
            subtitle: Text("made with ❤️ by flofriday"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                text: 'Diese App ist freie Software unter der MIT Lizenz. '
                    'Somit hat jede Person die Freiheit den Quellcode zu '
                    'untersuchen, Änderungen an diesem vorzunehemen und die '
                    'App mit oder ohne Änderungen zu redistributieren.\n\n',
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                      text: 'Warnung: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: 'Obwohl die Daten von einer offiziellen TU Wien '
                          'API kommen, ist diese App kein offizielles '
                          'Angebot der TU Wien!'),
                ],
              ),
            ),
          ),
          ButtonBar(
            buttonTextTheme: ButtonTextTheme.accent,
            alignment: MainAxisAlignment.start,
            children: [
              OutlineButton(
                  onPressed: () {
                    launchInBrowser(
                        "https://github.com/flofriday/TU_Wien_Addressbook");
                  },
                  //icon: FaIcon(FontAwesomeIcons.github),
                  child: Text("GitHub")),
              FlatButton(
                  onPressed: () {
                    launchInBrowser(
                        "https://github.com/flofriday/TU_Wien_Addressbook/blob/master/LICENSE");
                  },
                  child: Text("MIT Lizenz"))
            ],
          )
        ],
      ),
    );
  }
}
