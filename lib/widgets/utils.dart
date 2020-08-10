import 'package:tu_wien_addressbook/models/cookie_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> launchInBrowser(String url) async {
  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    );
  } else {
    throw 'Could not launch $url';
  }
}

Future<void> launchEmail(String email, String subject, String content) async {
  String url = "mailto:$email?subject=$subject&body=$content";

  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    );
  } else {
    throw 'Could not launch $url';
  }
}

Future<void> launchPhone(
  String phone,
) async {
  String url = "tel:" + phone;

  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    );
  } else {
    throw 'Could not launch $url';
  }
}

class MyRequest extends http.Request {
  @override
  Map<String, String> headers;

  MyRequest(String method, Uri url, {Map<String, String> headers})
      : this.headers = headers,
        super(method, url);
}

Future<String> getCookies() async {
  // STEP 1: Create a session, and collect the AuthState

  // We need to follow a couple of redirects so lets do this shit
  String sessionUrl = "https://tiss.tuwien.ac.at/admin/authentifizierung";
  //String sessionUrl = "https://login.tuwien.ac.at";
  CookieManager cookieJar = CookieManager();
  http.Client client = http.Client();
  http.StreamedResponse resp;

  while (true) {
    var headers = {"Cookie": cookieJar.getForUrl(Uri.parse(sessionUrl))};
    http.BaseRequest req =
        MyRequest('GET', Uri.parse(sessionUrl), headers: headers);
    req.followRedirects = false;
    resp = await client.send(req);
    cookieJar.addFromResponse(resp);

    if (!resp.isRedirect) {
      break;
    } else {
      sessionUrl = resp.headers['location'];
      if (sessionUrl.startsWith("/")) {
        sessionUrl = resp.request.url.origin + sessionUrl;
      }
      //print("Redirect to: ${resp.headers['location']}");
      if (sessionUrl == null) break;
    }
  }

  // Now we got the final url, so lets extract the AuthState from the url
  String authState = Uri.parse(sessionUrl).queryParameters['AuthState'];

  //print("Final url: $sessionUrl");
  //print("Code: ${resp.statusCode}");
  //print("Headers: ${resp.headers}");
  //print("Authstate: $authState");

  // STEP 2: Send a POST request to get the first TU Wien cookie, which we need
  //to get the second TU Wien cookie
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String user = prefs.getString('username');
  String password = prefs.getString('password');
  print("user: $user, password: $password");

  if (user == null || password == null) {
    print('No password or user');
    return "";
  }

  String url =
      "https://idp.zid.tuwien.ac.at/simplesaml/module.php/core/loginuserpass.php";

  var headers = {
    "Content-Type": "application/x-www-form-urlencoded",
    "Cookie": cookieJar.getForUrl(Uri.parse(url))
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

  print('Cookies: ');
  print(response.headers['set-cookie']);

  print("SAMLResponse: $samlResponse");
  print("RelayState: $relayState");

  // STEP 3: Make a second POST request to get the second TU Wien cookie, so
  // we can get the TISS cookie
  url = "https://login.tuwien.ac.at/auth/postResponse";

  headers = {
    "Content-Type": "application/x-www-form-urlencoded",
    "Cookie": cookieJar.getForUrl(Uri.parse(url)),
  };
  print(
      "LOGIN COOKIES: ${cookieJar.getForUrl(Uri.parse("https://login.tuwien.ac.at"))}");

  requestBody = {
    'SAMLResponse': samlResponse,
    'RelayState': relayState,
  };
  http.Request request = MyRequest('POST', Uri.parse(url), headers: headers);
  request.followRedirects = false;
  request.bodyFields = requestBody;
  http.StreamedResponse streamResponse = await client.send(request);
  cookieJar.addFromResponse(streamResponse);

  if (!streamResponse.isRedirect) return "";
  print("location: ${streamResponse.headers}");
  print("headers: ${streamResponse.request.headers}");
  print("status: ${streamResponse.statusCode}");

  // STEP 4: Now we need to get the TISS cookie
  //sessionUrl = "https://tiss.tuwien.ac.at/admin/authentifizierung";
  sessionUrl = streamResponse.headers['location'];
  while (true) {
    var headers = {"Cookie": cookieJar.getForUrl(Uri.parse(sessionUrl))};
    http.BaseRequest req =
        MyRequest('GET', Uri.parse(sessionUrl), headers: headers);
    req.followRedirects = false;
    resp = await client.send(req);
    cookieJar.addFromResponse(resp);

    if (!resp.isRedirect) {
      break;
    } else {
      sessionUrl = resp.headers['location'];
      print("Redirect to: ${resp.headers['location']}");
      if (sessionUrl == null) break;
    }
  }

  //print(cookieJar.getForUrl(Uri.parse("https://tiss.tuwien.ac.at")));
  print("");
  print(cookieJar);
  return cookieJar.getForUrl(Uri.parse("https://tiss.tuwien.ac.at"));
}
