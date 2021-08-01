import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tu_wien_addressbook/models/person.dart';
import 'package:tu_wien_addressbook/models/suggestion_manager.dart';
import 'package:tu_wien_addressbook/models/tiss.dart';
import 'package:tu_wien_addressbook/models/tiss_login_manager.dart';
import 'package:tu_wien_addressbook/screens/person_screen.dart';
import 'package:tu_wien_addressbook/widgets/person_entry.dart';
import 'package:http/http.dart' as http;

class PersonSearch extends SearchDelegate<Null> {
  TissLoginManager _tissManager = TissLoginManager();
  SuggestionManager _suggestionManager = SuggestionManager();
  Map<String, Tiss> _cache = Map();
  bool _employeeFilter = false;
  bool _studentFilter = false;
  bool _femaleFilter = false;
  bool _maleFilter = false;
  Random _rng = Random();

  PersonSearch()
      : super(
          searchFieldLabel: "Suche",
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  String _getNoResultEmoji() {
    var emojis = ["🤷‍♂️‍", "🤷‍♀️"];
    return emojis[(_rng.nextInt(emojis.length))];
  }

  Future<http.Response> _makeRequest(String query) async {
    // Get the Cookies
    String cookies = await _tissManager.getCookies()!;
    var headers = {"Cookie": cookies};

    // Make the request
    Uri apiSearchUri =
        Uri.https("tiss.tuwien.ac.at", "/api/person/v22/psuche", {
      "q": query,
      "max_treffer": "100",
      "preview_picture_uri": "true",
      "intern": "true",
      "locale": "de",
    });
    http.Response res = await http.get(apiSearchUri, headers: headers);
    return res;
  }

  // Tries to download the results from TISS, returns null if the mission went
  // sideways.
  Future<Tiss?> _getData(String query) async {
    // Check the cache
    if (_cache.containsKey(query)) return _cache[query];

    // Make the request
    http.Response resp = await _makeRequest(query);
    if (resp.statusCode != 200) return null;

    // Parse the json
    var map = jsonDecode(resp.body);
    Tiss data = Tiss.fromJson(map);

    // Add the data to the cache and return
    _cache[query] = data;
    return data;
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: theme.cardColor,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
      primaryColorBrightness: MediaQuery.of(context).platformBrightness,
      primaryTextTheme: theme.textTheme,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    Future<Tiss?> data = _getData(query);
    _suggestionManager.addSuggestion(query);

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return FutureBuilder<Tiss?>(
          future: data,
          builder: (BuildContext context, AsyncSnapshot<Tiss?> snapshot) {
            // Check for errors
            if (snapshot.hasError) {
              return SafeArea(
                child: Center(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "✈️",
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .headline3!
                                        .fontSize,
                                  ),
                        ),
                        Text(
                          "Ein Fehler ist aufgetreten beim Laden der Daten.",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ]),
                ),
              );
            }

            // Check if the data is ready
            if (!snapshot.hasData) {
              return Center(
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  CircularProgressIndicator(value: null),
                ]),
              );
            }

            // Check if the server answered successfully
            Tiss? data = snapshot.data;
            if (data == null) {
              return Center(
                  child:
                      Text("Ein Fehler ist aufgetreten beim Laden der Daten."));
            }

            // Show a error if there are no results
            if (data.results.length == 0) {
              return SafeArea(
                child: Center(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _getNoResultEmoji(),
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .headline3!
                                        .fontSize,
                                  ),
                        ),
                        Text(
                          "Niemanden gefunden.",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ]),
                ),
              );
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
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    height: 0,
                    indent: index == 0 ? 0 : (16 + 40 + 16).toDouble(),
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: FilterChip(
                              label: Text("Studierende"),
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

                                  if (_maleFilter && value) {
                                    _maleFilter = false;
                                  }
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

                                  if (_femaleFilter && value) {
                                    _femaleFilter = false;
                                  }
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8),
                          )
                        ],
                      ),
                    );
                  }

                  return PersonEntry(
                    results[index - 1],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PersonScreen(results[index - 1]),
                        ),
                      );
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
    Future<List<String>> futureSuggestions =
        _suggestionManager.getSuggestionsFor(query);

    return Container(
      color: Theme.of(context).cardColor,
      child: FutureBuilder(
          future: futureSuggestions,
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            if (!snapshot.hasData) return Container();

            List<String> data;
            if (snapshot.data == null) {
              data = [];
            } else {
              data = snapshot.data!;
            }

            return ListView.separated(
                itemCount: data.length,
                separatorBuilder: (context, index) => Divider(
                      height: 4,
                    ),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Icon(Icons.access_time),
                    title: Text(data[index]),
                    onTap: () {
                      query = data[index];
                      showResults(context);
                    },
                  );
                });
          }),
    );
  }
}
