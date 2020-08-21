import 'package:flutter/material.dart';

class ThridPartyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            isThreeLine: true,
            leading: Icon(Icons.description),
            title: Text("Lizenzen Dritter"),
            subtitle: Text(
                "Diese Bibliotheken haben mir geholfen die App zu entwickeln."),
          ),
          FlatButton(
            //textColor: Theme.of(context).accentColor,
            onPressed: () {
              showLicensePage(context: context);
            },
            child: Text("Lizenzen"),
          )
        ],
      ),
    );
  }
}
