import 'dart:convert';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tu_wien_addressbook/models/github_tag.dart';
import 'package:tu_wien_addressbook/models/semver.dart';
import 'package:http/http.dart' as http;

/// This class is used to check with GitHub if there is a new version available.
/// To achive its goal the class gets the name of the latest
/// tag (semantic versioning) and compares it to its own tag. If the tag on
/// GitHub is higher, it means that there is a new version.
class UpdateManager {
  UpdateManager();

  Future<bool> hasNewerVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    Semver currentVersion = Semver.parse(packageInfo.version);

    print("Downloading version from GitHub...");
    Uri url = Uri.parse(
        "https://api.github.com/repos/flofriday/TU_Wien_Addressbook/tags");
    var response = await http.get(url);
    if (response.statusCode != 200) {
      // Ok the either the internet / service is currently not availabel, or
      // we got ratelimited whatever. Just do not update the cache and
      // say that there is no version available.
      print(
          'Requesting the version from GitHub returned ${response.statusCode}');
      return false;
    }

    List<Tag> tags = (jsonDecode(response.body) as List)
        .map((data) => Tag.fromJSON(data))
        .toList();

    // Check if there are maybe just no versions.
    if (tags.isEmpty) return false;

    // Parse the newest available version and add it to the cache
    Semver updateVersion = Semver.parse(tags[0].name);
    print("GitHub version: ${updateVersion.toString()}");
    print("Current version: ${currentVersion.toString()}");

    return currentVersion.compareTo(updateVersion) < 0;
  }
}
