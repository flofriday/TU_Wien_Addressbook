import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tu_wien_addressbook/models/tiss_login_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  void _login() async {
    setState(() {
      _loading = true;
    });

    TissLoginManager loginManager = TissLoginManager();
    bool ok = await loginManager.updateCredentials(
        _usernameController.text, _passwordController.text);
    setState(() {
      _loading = false;
    });

    // Return if it was successfull
    if (ok) {
      Navigator.pop(context);
      return;
    }

    // Show a dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login Failed'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Maybe your username or password is wrong?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('CLOSE'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _logout() async {
    TissLoginManager loginManager = TissLoginManager();
    await loginManager.logout();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildLoginCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              labelText: 'Username',
            ),
            readOnly: _loading,
            controller: _usernameController,
          ),
          TextField(
            decoration: const InputDecoration(
              icon: Icon(Icons.lock),
              labelText: 'Password',
            ),
            obscureText: true,
            readOnly: _loading,
            controller: _passwordController,
          ),
          Padding(
            padding: EdgeInsets.only(top: 8, bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!_loading)
                  ElevatedButton(
                    onPressed: () => _login(),
                    child: Text("LOGIN"),
                  ),
                if (_loading)
                  Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: CircularProgressIndicator()),
                if (_loading)
                  ElevatedButton(
                    onPressed: null,
                    child: Text("LOGIN"),
                  )
              ],
            ),
          )
        ]),
      ),
    );
  }

  Widget _buildUserCard() {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          SharedPreferences prefs = snapshot.data;

          return Card(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.person),
                title: Text(prefs.getString('username')!),
                subtitle: Text('Successfully logged in'),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                      ),
                      child: const Text('Logout'),
                      onPressed: () {
                        _logout();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TISS Login"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            FutureBuilder(
              future: TissLoginManager().isLoggedIn(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());

                if (snapshot.data == false) return _buildLoginCard();

                return _buildUserCard();
              },
            ),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("TISS protects students privacy, therefore you "
                        "need to be logged in to find them.\n"
                        "Without logging in you can still search for faculty "
                        "staff.\n\n"
                        "Your credentials are only saved locally on this "
                        "device and are only ever used to authenticate "
                        "you with TISS."),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
