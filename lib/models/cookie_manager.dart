import 'package:http/http.dart' as http;

// A very simple Cookie manager that can save cookies from responses for
// future requests.
// Note: it ignores the path of a variable and the expiration data
class CookieManager {
  Map<String, Map<String, String>> _data = Map();

  CookieManager();

  void addFromResponse(http.BaseResponse resp) {
    String host = resp.request.url.host;
    String rawCookies = resp.headers['set-cookie'];
    if (rawCookies == null || rawCookies == "") return;

    List<String> cookies = rawCookies.split(",");
    print("COOKIE: $rawCookies ($host)");

    for (String cookie in cookies) {
      if (!cookie.contains("=")) continue;

      cookie = cookie.split(";")[0];
      String cookieName = cookie.split("=")[0];
      String cookieData = cookie.split("=")[1];

      if (!_data.containsKey(host)) _data[host] = Map();
      _data[host][cookieName] = cookieData;
    }
  }

  String getForUrl(Uri url) {
    String cookie = "";
    if (!_data.containsKey(url.host)) return "";

    _data[url.host].forEach((k, v) {
      cookie += k + "=" + v + ";";
    });

    return cookie;
  }

  @override
  String toString() {
    String out = "";
    _data.forEach((domain, value) {
      value.forEach((name, data) {
        out += "$domain: $name=$data\n";
      });
    });

    return out;
  }
}
