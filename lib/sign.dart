import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
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
