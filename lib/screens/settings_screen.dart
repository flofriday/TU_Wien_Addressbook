import 'package:flutter/material.dart';
import 'package:tu_wien_addressbook/widgets/login_card.dart';
import 'package:tu_wien_addressbook/widgets/opensource_card.dart';
import 'package:tu_wien_addressbook/widgets/thirdparty_card.dart';

class SettingsScreen extends StatelessWidget {
  static const EdgeInsets cardPadding =
      EdgeInsets.only(top: 10, left: 10, right: 10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Einstellungen"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: cardPadding,
            child: LoginCard(),
          ),
          Padding(
            padding: cardPadding,
            child: OpenSourceCard(),
          ),
          Padding(
            padding: cardPadding,
            child: ThridPartyCard(),
          ),
        ],
      ),
    );
  }
}
