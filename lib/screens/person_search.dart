import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tu_wien_addressbook/models/person.dart';
import 'package:tu_wien_addressbook/models/tiss.dart';
import 'package:tu_wien_addressbook/models/tiss_login_manager.dart';
import 'package:tu_wien_addressbook/widgets/person_entry.dart';
import 'package:uri/uri.dart';
import 'package:http/http.dart' as http;

class PersonSearch extends SearchDelegate<Person> {
  TissLoginManager _tissManager = TissLoginManager();
  bool _employeeFilter = false;
  bool _studentFilter = false;
  bool _femaleFilter = false;
  bool _maleFilter = false;

  PersonSearch() : super(searchFieldLabel: "Suche");

  Future<http.Response> _makeRequest(String query) async {
    var template = new UriTemplate(
        "https://tiss.tuwien.ac.at/api/person/v22/psuche?q={query}&max_treffer=50&intern=true");
    String apiUri = template.expand({'query': query});

    String cookies = await _tissManager.getCookies();
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

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return FutureBuilder<http.Response>(
          future: response,
          builder:
              (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
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

            // Filter the results
            Iterable<Person> unfiltered = data.results;
            if (_studentFilter) {
              unfiltered = unfiltered.where((Person p) => p.student != null);
            }
            if (_employeeFilter) {
              unfiltered = unfiltered.where((Person p) => p.employee != null);
            }
            if (_femaleFilter) {
              unfiltered = unfiltered.where((Person p) => p.gender == "W");
            }
            if (_maleFilter) {
              unfiltered = unfiltered.where((Person p) => p.gender == "M");
            }
            List<Person> results = unfiltered.toList();

            // Build the ui
            return Container(
              color: Theme.of(context).cardColor,
              child: ListView.separated(
                itemCount: results.length + 1,
                separatorBuilder: (BuildContext context, int index) => Divider(
                  height: 0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: FilterChip(
                              label: Text("Studenten"),
                              selected: _studentFilter,
                              onSelected: (bool value) {
                                setState(() {
                                  _studentFilter = value;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: FilterChip(
                              label: Text("Angestellte"),
                              selected: _employeeFilter,
                              onSelected: (bool value) {
                                setState(() {
                                  _employeeFilter = value;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: FilterChip(
                              label: Text("weiblich"),
                              selected: _femaleFilter,
                              onSelected: (bool value) {
                                setState(() {
                                  _femaleFilter = value;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: FilterChip(
                              label: Text("männlich"),
                              selected: _maleFilter,
                              onSelected: (bool value) {
                                setState(() {
                                  _maleFilter = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return GestureDetector(
                    child: PersonEntry(results[index - 1]),
                    onTap: () {
                      close(context, results[index - 1]);
                    },
                  );
                },
              ),
            );
          });
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
