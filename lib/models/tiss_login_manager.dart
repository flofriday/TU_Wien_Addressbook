import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tu_wien_addressbook/models/cookie_manager.dart';

/// A custom request class as the default http.Request class doesn't allow
/// me to set headers in the constructor.
class _MyRequest extends http.Request {
  @override
  Map<String, String> headers;

  /// A constructor similar to http.Request but, that allows you to set headers.
  _MyRequest(String method, Uri url, {required Map<String, String> headers})
      : this.headers = headers,
        super(method, url);
}

/// A class to load the necessary TISS cookies
///
/// This class makes heavy use of shared preferences, and can only log in if
/// there is a 'username' and 'password' field in the shared prefrences with
/// valid credentials. Furthermore, this class also saves the cookie in the
/// shared preferences with the key 'tisscookie' and a timestamp
/// (in milliseconds since epoche) with the key 'tisscookietime'.
class TissLoginManager {
  static final TissLoginManager _instance = TissLoginManager._internal();

  Future<SharedPreferences> futurePrefs = SharedPreferences.getInstance();
  Future<String>? tissCookies;
  Future<bool>? loggedIn;

  factory TissLoginManager() {
    return _instance;
  }

  TissLoginManager._internal() {
    print("Loading cookies...");
    this.tissCookies = _loadCookies();
  }

  // Get the cookies for the logged in user, if the user is not logged in,
  // the string in the future will be empty.
  Future<String>? getCookies() {
    return tissCookies;
  }

  // This updates the credentials, and notifies the caller with the bool in the
  // future if the credentials worked.
  Future<bool> updateCredentials(String username, String password) async {
    SharedPreferences prefs = await futurePrefs;
    await prefs.setString('username', username);
    await prefs.setString('password', password);
    await prefs.remove('tisscookie');
    await prefs.remove('tisscookietime');

    this.tissCookies = _loadCookies();
    String cookie = await this.tissCookies!;
    if (cookie != "") return true;

    // So the entered credentials are not correct so delete them
    await prefs.remove('username');
    await prefs.remove('password');
    return false;
  }

  Future<void> logout() async {
    SharedPreferences prefs = await futurePrefs;
    await prefs.remove('tisscookie');
    await prefs.remove('tisscookietime');
    await prefs.remove('username');
    await prefs.remove('password');

    this.tissCookies = _loadCookies();
    await this.tissCookies;
  }

  Future<bool> isLoggedIn() async {
    String cookie = await this.tissCookies!;
    return cookie != "";
  }

  Future<String> _loadCookies() async {
    // STEP 0: Check if there are existing cookies
    SharedPreferences prefs = await futurePrefs;
    String? savedTissCookie = prefs.getString('tisscookie');
    int? rawDateTime = prefs.getInt('tisscookietime');

    // Check if there is any data in the prefrences
    if (savedTissCookie != null &&
        savedTissCookie != "" &&
        rawDateTime != null) {
      DateTime savedTissCookieTime =
          DateTime.fromMillisecondsSinceEpoch(prefs.getInt('tisscookietime')!);

      if (DateTime.now().difference(savedTissCookieTime).inSeconds <
          Duration(minutes: 30).inSeconds) {
        return savedTissCookie;
      }
    }

    // Check if there is a saved username and password.
    // Because if not we don't need to try to login
    String? user = prefs.getString('username');
    String? password = prefs.getString('password');
    if (user == null || user == "" || password == null || password == "") {
      print('No password or user');
      return "";
    }

    // STEP 1: Create a session, and collect the AuthState

    // We need to follow a couple of redirects so lets do this shit
    String sessionUrl = "https://tiss.tuwien.ac.at/admin/authentifizierung";
    CookieManager cookieJar = CookieManager();
    http.Client client = http.Client();
    http.StreamedResponse resp;

    while (true) {
      var headers = {"Cookie": cookieJar.getForUrl(Uri.parse(sessionUrl))};
      http.BaseRequest req =
          _MyRequest('GET', Uri.parse(sessionUrl), headers: headers);
      req.followRedirects = false;
      resp = await client.send(req);
      cookieJar.addFromResponse(resp);

      if (!resp.isRedirect) {
        break;
      } else {
        sessionUrl = resp.headers['location']!;
        if (sessionUrl.startsWith("/")) {
          sessionUrl = resp.request!.url.origin + sessionUrl;
        }
      }
    }

    // Now we got the final url, so lets extract the AuthState from the url
    String authState = Uri.parse(sessionUrl).queryParameters['AuthState']!;

    // STEP 2: Send a POST request to get the first TU Wien cookie, which we need
    //to get the second TU Wien cookie

    Uri url = Uri.parse(
        "https://idp.zid.tuwien.ac.at/simplesaml/module.php/core/loginuserpass.php");

    var headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      "Cookie": cookieJar.getForUrl(url)
    };

    var requestBody = {
      'username': user,
      'password': password,
      'totp': '',
      'AuthState': authState
    };

    http.Response response =
        await client.post(url, headers: headers, body: requestBody);
    cookieJar.addFromResponse(response);

    // Get the parameter
    List<String> lines = response.body.split("\n");
    String samlResponse = "";
    String relayState = "";
    for (String line in lines) {
      if (line.contains("SAMLResponse")) {
        List<String> tags = line.split(" ");
        for (String tag in tags) {
          if (tag.contains("value")) {
            samlResponse = tag.split("\"")[1];
          }
        }
      } else if (line.contains("RelayState")) {
        List<String> tags = line.split(" ");
        for (String tag in tags) {
          if (tag.contains("value")) {
            relayState = tag.split("\"")[1];
          }
        }
      }
    }

    // STEP 3: Make a second POST request to get the second TU Wien cookie, so
    // we can get the TISS cookie
    url = Uri.parse("https://login.tuwien.ac.at/auth/postResponse");

    headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      "Cookie": cookieJar.getForUrl(url),
    };

    requestBody = {
      'SAMLResponse': samlResponse,
      'RelayState': relayState,
    };
    http.Request request = _MyRequest('POST', url, headers: headers);
    request.followRedirects = false;
    request.bodyFields = requestBody;
    http.StreamedResponse streamResponse = await client.send(request);
    cookieJar.addFromResponse(streamResponse);

    if (!streamResponse.isRedirect) return "";
    print("location: ${streamResponse.headers}");
    print("headers: ${streamResponse.request!.headers}");
    print("status: ${streamResponse.statusCode}");

    // STEP 4: Now we need to get the TISS cookie
    sessionUrl = streamResponse.headers['location']!;
    while (true) {
      var headers = {"Cookie": cookieJar.getForUrl(Uri.parse(sessionUrl))};
      http.BaseRequest req =
          _MyRequest('GET', Uri.parse(sessionUrl), headers: headers);
      req.followRedirects = false;
      resp = await client.send(req);
      cookieJar.addFromResponse(resp);

      if (!resp.isRedirect) {
        break;
      } else {
        sessionUrl = resp.headers['location']!;
        print("Redirect to: ${resp.headers['location']}");
        if (sessionUrl == null) break;
      }
    }

    // Save the cookie for future use
    String tissCookie =
        cookieJar.getForUrl(Uri.parse("https://tiss.tuwien.ac.at"));
    await prefs.setString('tisscookie', tissCookie);
    await prefs.setInt('tisscookietime', DateTime.now().millisecondsSinceEpoch);

    return tissCookie;
  }
}
