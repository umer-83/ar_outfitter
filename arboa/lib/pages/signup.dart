import 'package:flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
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
            padding: EdgeInsetsDirectional.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('images/ARBOA-logos_transparent.png'),
                      width: 100,
                      height: 100,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                  ],
                ),
                SizedBox(height: 50),
                Text('Signup here',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _userNameTextController,
                        obscureText: false,
                        enableSuggestions: !false,
                        autocorrect: !false,
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2)),
                            contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                            labelText: 'Username',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2))),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Username is required';
                          }
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _emailTextController,
                        obscureText: false,
                        enableSuggestions: !false,
                        autocorrect: !false,
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2)),
                            contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.mail),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2))),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email is required';
                          }
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _passwordTextController,
                        obscureText: true,
                        enableSuggestions: !true,
                        autocorrect: !true,
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2)),
                            contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    color: Colors.greenAccent, width: 2))),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Password is required';
                          }
                        },
                      ),
                      SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                            onPressed: () {
                              FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: _emailTextController.text,
                                      password: _passwordTextController.text)
                                  .then((value) {
                                print("Created New Account");
                                FocusScope.of(context).unfocus();
                                Navigator.pushReplacementNamed(
                                    context, '/home');
                              }).onError((error, stackTrace) {
                                print("Error ${error.toString()}");
                              });
                            },
                            child: Text("Register"),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(40.0),
                                        side:
                                            BorderSide(color: Colors.blue))))),
                      )
                    ],
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