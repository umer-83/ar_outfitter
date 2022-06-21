// ignore_for_file: missing_return
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFFFFFFF),
      body: SafeArea(
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
                      width: 200,
                      height: 200),
                  /*SizedBox(
                        width: ,
                      ),*/
                ],
              ),
              //SizedBox(height: 5),
              Text('Welcome!',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 70, 0, 0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailTextController,
                      obscureText: false,
                      enableSuggestions: true,
                      autocorrect: !false,
                      style: TextStyle(fontSize: 14,),
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2)),
                          contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.mail),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
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
                      style: TextStyle(fontSize: 14),
                      controller: passwordTextController,
                      obscureText: true,
                      enableSuggestions: !true,
                      autocorrect: !true,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2)),
                          contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock,),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2))),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Password is required';
                              }
                            },
                    ),
                    SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            signin();
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Color(0xff1C1C1C)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      side: BorderSide(color:Color(0xff1C1C1C)))))),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text("Not a Member yet?"),
                      SizedBox(width: 10),
                      GestureDetector(
                        child: Text('SignUp here',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.blue)),
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/signup');
                        },
                      ),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future signin() async{
    try {
     await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailTextController.text,
              password: passwordTextController.text)
          .then((value) =>
        Navigator.pushReplacementNamed(context, '/home'));
    } on FirebaseAuthException catch (e) {
      if (e.message ==
          'There is no user record corresponding to this identifier. The user may have been deleted.') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
          elevation: 1,
          margin: EdgeInsets.fromLTRB(20, 10, 20, 150),
          content:  Text("Invalid e-mail address.", style: TextStyle(fontSize: 14, color: Colors.white),textAlign: TextAlign.center,),
          duration: Duration(seconds: 7),
        ),);
      } else if (e.message ==
          'The password is invalid or the user does not have a password.') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
          elevation: 1,
          margin: EdgeInsets.fromLTRB(20, 10, 20, 150),
          content:  Text("Invalid password.", style: TextStyle(fontSize: 14, color: Colors.white) ,textAlign: TextAlign.center,),
          duration: Duration(seconds: 7),
        ),
        );
      }
      print(e.toString());
    }
  }
}
