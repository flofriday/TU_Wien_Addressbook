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
  Map<String, List<Person>> _cache = Map();
  bool _employeeFilter = false;
  bool _studentFilter = false;
  bool _femaleFilter = false;
  bool _maleFilter = false;
  Random _rng = Random();
  double _scrollOffset = 0;

  PersonSearch()
      : super(
          searchFieldLabel: "Search",
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  String _getNoResultEmoji() {
    var emojis = ["🤷‍♂️‍", "🤷‍♀️"];
    return emojis[(_rng.nextInt(emojis.length))];
  }

  /// Make a request to search for the name of a person
  Future<http.Response> _makePersonRequest(String query) async {
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
      "locale": "en",
    });
    http.Response res = await http.get(apiSearchUri, headers: headers);
    return res;
  }

  /// Make a request to search for a person by their matriculation number
  Future<http.Response> _makeMnrRequest(String query) async {
    // Get the Cookies
    String cookies = await _tissManager.getCookies()!;
    var headers = {"Cookie": cookies};

    // Make the request
    Uri apiSearchUri =
        Uri.https("tiss.tuwien.ac.at", "/api/person/v22/mnr/$query", {
      "preview_picture_uri": "true",
      "intern": "true",
      "locale": "en",
    });
    http.Response res = await http.get(apiSearchUri, headers: headers);
    return res;
  }

  // Tries to download the results from TISS, returns null if the mission went
  // sideways.
  Future<List<Person>?> _getData(String query) async {
    // Check the cache
    if (_cache.containsKey(query)) return _cache[query];

    // Since we get new data now, we should reset the position of the scroll
    _scrollOffset = 0;

    // Check if the query is a matriculation number
    RegExp mrnRegex = RegExp("[01]?[0-9]{7}");
    if (mrnRegex.hasMatch(query)) {
      // Load by matriculation number

      // Make the request
      http.Response resp = await _makeMnrRequest(query);
      if (resp.statusCode == 404) return [];
      if (resp.statusCode != 200) return null;

      // Parse the json
      var map = jsonDecode(resp.body);
      Person data = Person.fromJson(map);

      // Add the data to the cache and return
      _cache[query] = [data];
      return [data];
    } else {
      // Load by name

      // Make the request
      http.Response resp = await _makePersonRequest(query);
      if (resp.statusCode != 200) return null;

      // Parse the json
      var map = jsonDecode(resp.body);
      Tiss data = Tiss.fromJson(map);

      // Add the data to the cache and return
      _cache[query] = data.results;
      return data.results;
    }
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    if (theme.brightness == Brightness.dark) return theme;

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
    Future<List<Person>?> data = _getData(query);
    _suggestionManager.addSuggestion(query);

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return FutureBuilder<List<Person>?>(
          future: data,
          builder:
              (BuildContext context, AsyncSnapshot<List<Person>?> snapshot) {
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
                          "An error occoured during loading.",
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
            List<Person>? data = snapshot.data;
            if (data == null) {
              return Center(child: Text("An error occoured during loading."));
            }

            // Show a error if there are no results
            if (data.length == 0) {
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
                          "Noone found.",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ]),
                ),
              );
            }

            // Filter the results
            Iterable<Person> unfiltered = data;
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

            // Set up a scroll controller, this is just to update the internal
            // variable _scrollOffset, so that we don't lose the scroll position
            // when we click on one item.
            ScrollController controller =
                ScrollController(initialScrollOffset: _scrollOffset);
            controller.addListener(() {
              _scrollOffset = controller.position.pixels;
            });

            // Build the ui
            var result = Container(
              color: Theme.of(context).cardColor,
              child: ListView.separated(
                controller: controller,
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
                              label: Text("stundent"),
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
                              label: Text("employee"),
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
                              label: Text("female"),
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
                              label: Text("male"),
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
                      //Navigator.push(
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
            //_controller.jumpTo(10);
            return result;
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
