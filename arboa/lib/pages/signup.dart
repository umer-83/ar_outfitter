// ignore_for_file: missing_return

import 'package:flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController userNameTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email, password, usersname;
  bool remember = false;
  final List<String> errors = [];
// func with named parameter
  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFFFFFFF),
      body: SafeArea(
          child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
            padding: EdgeInsetsDirectional.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('images/ARBOA-logos_transparent.png'),
                      width: 140,
                      height: 140,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text('Signup here!',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: userNameTextController,
                            obscureText: false,
                            enableSuggestions: !false,
                            autocorrect: !false,
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  borderSide:
                                      BorderSide(color: Colors.blue, width: 2),
                                ),
                                contentPadding:
                                    EdgeInsets.fromLTRB(15, 15, 15, 15),
                                labelText: 'Username',
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2))),
                            onSaved: (newValue) => usersname = newValue,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Username is required!';
                              }
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: emailTextController,
                            obscureText: false,
                            enableSuggestions: !false,
                            autocorrect: !false,
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  borderSide:
                                      BorderSide(color: Colors.blue, width: 2)),
                              contentPadding:
                                  EdgeInsets.fromLTRB(15, 15, 15, 15),
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.mail),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2),
                              ),
                            ),
                            onSaved: (newValue) => email = newValue,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Email is required!';
                              }
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: passwordTextController,
                            obscureText: true,
                            enableSuggestions: !true,
                            autocorrect: !true,
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2)),
                                contentPadding:
                                    EdgeInsets.fromLTRB(15, 15, 15, 15),
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.lock),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    borderSide: BorderSide(
                                        color: Colors.greenAccent, width: 2))),
                            onSaved: (newValue) => password = newValue,
                            onChanged: (value) {
                              if (value.isNotEmpty &&
                                  errors.contains('kPassNullError')) {
                                removeError(error: 'kPassNullError');
                              } else if (value.length >= 6) {
                                removeError(error: 'kShortPassError');
                              }
                              // In case a user removed some characters below the threshold, show alert
                              else if (value.length < 6 && value.isNotEmpty) {
                                addError(error: 'kShortPassError');
                              }
                              return null;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                addError(error: 'kPassNullError');
                                removeError(error: 'kShortPassError');
                                return 'Password is required!';
                              } else if (value.length < 6 && value.isNotEmpty) {
                                addError(error: 'kShortPassError');
                                return 'Password must be 6 or > 6 digits.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 40),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                          email: emailTextController.text,
                                          password: passwordTextController.text)
                                      .then((value) {
                                    print("Created New Account");
                                    FocusScope.of(context).unfocus();
                                    Navigator.pushReplacementNamed(
                                        context, '/home');
                                  }).onError((error, stackTrace) {
                                    print("Error \\\${error.toString()}");
                                  });
                                }
                              },
                              child: Text("Register"),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color(0xff1C1C1C)),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          side: BorderSide(
                                              color: Color(0xff1C1C1C))))),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text("Already a member?"),
                      SizedBox(width: 10),
                      GestureDetector(
                        child: Text('Login here',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.blue)),
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                      ),
                    ])
                  ],
                ))
              ],
            )),
      )),
    );
  }
}
// TODO Implement this library.