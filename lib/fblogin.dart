import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class fblogin extends StatefulWidget {
  @override
  _fbloginState createState() => _fbloginState();
}

class _fbloginState extends State<fblogin> {
  bool isLoggedIn = false;
  String _message = 'Log in/out by pressing the buttons below.';

  void onLoginStatusChanged(bool isLoggedIn) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
    });
  }

  void initiateFacebookLogin() async {
    var facebookLogin = FacebookLogin();
    var facebookLoginResult = await facebookLogin.logIn(['email']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.loggedIn:
        print("LoggedIn");
        onLoginStatusChanged(true);
        break;
    }
  }

  Future<Null> _logOut() async {
    var facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
    _showMessage('Logged out.');
  }

  void _showMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Facebook Login"),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: isLoggedIn
                  ? Text("Logged In")
                  : RaisedButton(
                      child: Text("Login with Facebook"),
                      onPressed: () => initiateFacebookLogin(),
                    ),
            ),
            Center(
              child: RaisedButton(
                onPressed: _logOut,
                child: new Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
