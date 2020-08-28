import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

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
            textTheme: ButtonTextTheme.accent,
            onPressed: () async {
              PackageInfo packageInfo = await PackageInfo.fromPlatform();
              showLicensePage(
                context: context,
                applicationName: packageInfo.appName,
                applicationVersion: packageInfo.version,
                applicationIcon: Image(
                  image: AssetImage('logo_small.png'),
                  height: 100,
                ),
              );
            },
            child: Text("Lizenzen"),
          )
        ],
      ),
    );
  }
}
