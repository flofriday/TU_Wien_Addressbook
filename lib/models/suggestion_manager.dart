import 'package:shared_preferences/shared_preferences.dart';

class SuggestionManager {
  Future<SharedPreferences> futurePrefs = SharedPreferences.getInstance();

  Future<List<String>> getSuggestions() async {
    SharedPreferences prefs = await futurePrefs;
    return prefs.getStringList('suggestions') ?? [];
  }

  Future<List<String>> getSuggestionsFor(String query) async {
    List<String> suggestions = await getSuggestions();
    suggestions = suggestions
        .where((element) =>
            element.toLowerCase().contains(query.toLowerCase().trim()))
        .toList();
    return suggestions;
  }

  Future<void> addSuggestion(String value) async {
    // Load the current suggestions
    SharedPreferences prefs = await futurePrefs;
    List<String> current = prefs.getStringList('suggestions') ?? [];
    if (current.length > 99) current.removeRange(99, current.length);

    // Don't add the new suggestion if it is empty or the same as the last
    value = value.trim();
    if (value.isEmpty) {
      return;
    }
    if (current.isNotEmpty && value == current[0]) {
      return;
    }

    // If that query is already in the history, we just want to move it to the
    // top
    String _value = value.toLowerCase();
    for (int i = 0; i < current.length; i++) {
      if (_value == current[i].toLowerCase()) current.removeAt(i);
    }

    // Add the new value
    List<String> newSuggestions = [value];
    newSuggestions.addAll(current);
    await prefs.setStringList('suggestions', newSuggestions);
  }
}
