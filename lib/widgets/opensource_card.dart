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
                text: 'This app is free software under the MIT license'
                    'This app is free software under the MIT license. '
                    'Therefore everyone can view, edit, and redistribute the '
                    'sourcecode with or without changes.\n\n',
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                      text: 'Disclaimer: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: ' While the data this app displays, comes from an '
                          'official TU Wien API, the app itself is not '
                          'official!'),
                ],
              ),
            ),
          ),
          ButtonBar(
            buttonTextTheme: ButtonTextTheme.accent,
            children: [
              TextButton(
                  onPressed: () {
                    launchInBrowser(
                        "https://github.com/flofriday/TU_Wien_Addressbook/blob/master/LICENSE");
                  },
                  child: Text("MIT Lizenz")),
              OutlinedButton(
                  onPressed: () {
                    launchInBrowser(
                        "https://github.com/flofriday/TU_Wien_Addressbook");
                  },
                  //icon: FaIcon(FontAwesomeIcons.github),
                  child: Text("GitHub")),
            ],
          )
        ],
      ),
    );
  }
}
