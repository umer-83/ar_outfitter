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
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFFFFFFF),
      body: SafeArea(
          child: Padding(
              padding: EdgeInsetsDirectional.all(25),
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
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 70, 0, 0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailTextController,
                          obscureText: false ,
                          enableSuggestions: !false,
                          autocorrect: !false,
                          style: TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  borderSide:
                                      BorderSide(color: Colors.blue, width: 2)),
                              contentPadding:
                                  EdgeInsets.fromLTRB(15, 15, 15, 15),
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.mail),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2))),
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
                          controller: _passwordTextController,
                          obscureText: true,
                          enableSuggestions: !true,
                          autocorrect: !true,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  borderSide:
                                      BorderSide(color: Colors.blue, width: 2)),
                              contentPadding:
                                  EdgeInsets.fromLTRB(15, 15, 15, 15),
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2))),
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
                                try{
                                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((value) {
                    Navigator.pushReplacementNamed(context, '/home' );});
                                } on FirebaseAuthException catch (error) {
      Fluttertoast.showToast(msg: error.message,gravity: ToastGravity.TOP,);
    }
                                
                  
                              },
                              child: Text("Login", style: TextStyle(fontSize: 14),),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.blue),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40.0),
                                          side: BorderSide(
                                              color: Colors.blue))))),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Not a Member yet?"),
                            SizedBox(width: 10),
                            GestureDetector(
                              child: Text('SignUp here',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue)),
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                    context, '/signup');
                              },
                            )
                          ])
                    ],
                  ))
                ],
              ))),
    );
  }
}
// TODO Implement this library.