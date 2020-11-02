import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class sign extends StatefulWidget {
  @override
  _signState createState() => _signState();
}

class _signState extends State<sign> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success;
  String _userEmail;

  void _signInWithEmailAndPassword() async {
    FirebaseUser user = (await _auth.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    ))
        .user;

    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email;
      });
    } else {
      setState(() {
        _success = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: [
            FlatButton(
                onPressed: () async {
                  final FirebaseUser user = await _auth.currentUser();
                  if (user == null) {
                    print("null");
                    Fluttertoast.showToast(
                        msg: "Nothing to show",
                        gravity: ToastGravity.BOTTOM,
                        textColor: Colors.white,
                        backgroundColor: Colors.red[300]);
                    return;
                  }
                  await _auth.signOut();
                  final String uid = user.uid;
                  print("Something");
                  Fluttertoast.showToast(
                      msg: uid + "signed Off",
                      gravity: ToastGravity.BOTTOM,
                      textColor: Colors.white,
                      backgroundColor: Colors.red[300]);
                },
                child: Text(
                  "SignOut",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: SafeArea(
          child: Align(
              alignment: Alignment.center,
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          controller: _emailController,
                          autocorrect: true,
                          decoration: InputDecoration(
                            hintText: "Email",
                            suffixIcon: IconButton(
                                icon: Icon(Icons.cancel_rounded),
                                onPressed: () {
                                  _emailController.clear();
                                }),
                            labelText: "Email",
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Enter Email";
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          autocorrect: true,
                          obscureText: true,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: Icon(Icons.cancel),
                                onPressed: () {
                                  _passwordController.clear();
                                }),
                            hintText: "Password",
                            labelText: "Password",
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Enter Password";
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: RaisedButton(
                            child: Text("Submit"),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                _signInWithEmailAndPassword();
                                _emailController.clear();
                                _passwordController.clear();
                              } else {
                                print("Not valid");
                              }
                            }),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          _success == null
                              ? ''
                              : (_success
                                  ? 'Successfully signed in ' + _userEmail
                                  : 'Sign in failed'),
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    ],
                  ))),
        ));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
