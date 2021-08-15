// Model for the very popular semantic versioning
// https://semver.org/
class Semver implements Comparable {
  int major;
  int minor;
  int patch;

  Semver(this.major, this.minor, this.patch);

  static Semver parse(String text) {
    List<String> parts = text.split(".");

    if (parts.length != 3)
      throw "Semanticversining Validation Error (not enough numbers)";

    return Semver(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  @override
  int compareTo(dynamic other) {
    if (this.major < other.major) return -1;
    if (this.major > other.major) return 1;

    if (this.minor < other.minor) return -1;
    if (this.minor > other.minor) return 1;

    if (this.patch < other.patch) return -1;
    if (this.patch > other.patch) return 1;

    return 0;
  }

  @override
  String toString() {
    return "$major.$minor.$patch";
  }
}
