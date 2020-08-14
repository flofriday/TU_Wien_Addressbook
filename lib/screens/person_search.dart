import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tu_wien_addressbook/models/person.dart';
import 'package:tu_wien_addressbook/models/tiss.dart';
import 'package:tu_wien_addressbook/models/tiss_login_manager.dart';
import 'package:tu_wien_addressbook/widgets/person_entry.dart';
import 'package:uri/uri.dart';
import 'package:http/http.dart' as http;

class PersonSearch extends SearchDelegate<Person> {
  TissLoginManager tissManager = TissLoginManager();

  PersonSearch() : super(searchFieldLabel: "Suche");

  Future<http.Response> _makeRequest(String query) async {
    var template = new UriTemplate(
        "https://tiss.tuwien.ac.at/api/person/v22/psuche?q={query}&max_treffer=50&intern=true");
    String apiUri = template.expand({'query': query});

    String cookies = await tissManager.getCookies();
    var headers = {"Cookie": cookies};
    print(headers);
    var res = await http.get(apiUri, headers: headers);
    return res;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    Future<http.Response> response = _makeRequest(query);

    return FutureBuilder<http.Response>(
        future: response,
        builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
          // Check if the data is ready
          if (!snapshot.hasData) {
            return Center(
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                CircularProgressIndicator(value: null),
                //Text("Lade..."),
              ]),
            );
          }

          // Check if the server answered successfully
          http.Response resp = snapshot.data;
          if (resp.statusCode != 200) {
            return Center(
                child:
                    Text("Ein Fehler ist aufgetreten beim laden der Daten."));
          }

          // Decode the json
          var map = jsonDecode(resp.body);
          Tiss data = Tiss.fromJson(map);

          // Show a error if there are no results
          if (data.results.length == 0) {
            return Center(child: Text("Niemanden gefunden. 🤬"));
          }

          return ListView.builder(
              itemCount: data.results.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  child: PersonEntry(data.results[index]),
                  onTap: () {
                    close(context, data.results[index]);
                  },
                );
              });
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
