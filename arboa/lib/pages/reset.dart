import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetScreen extends StatefulWidget {
  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  TextEditingController emailTextController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Color(0xff1C1C1C),
        centerTitle: true,
        title: Text(
          "Reset Password",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: emailTextController,
                  obscureText: false,
                  enableSuggestions: !false,
                  autocorrect: !false,
                  style: TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(color: Colors.blue, width: 2)),
                      contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.mail),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2))),
                ),
                SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        await auth.sendPasswordResetEmail(
                            email: emailTextController.text,
                            );
                      } on FirebaseAuthException catch (e) {
                        if (e.message ==
                            'There is no user record corresponding to this identifier. The user may have been deleted.') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.blue,
                              behavior: SnackBarBehavior.floating,
                              elevation: 1,
                              margin: EdgeInsets.fromLTRB(20, 10, 20, 150),
                              content: Text(
                                "No record found.",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              duration: Duration(seconds: 5),
                            ),
                          );
                        }
                        
                        if (e.message == 'Given String is empty or null') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.blue,
                              behavior: SnackBarBehavior.floating,
                              elevation: 1,
                              margin: EdgeInsets.fromLTRB(20, 10, 20, 150),
                              content: Text(
                                "E-mail address is required.",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              duration: Duration(seconds: 5),
                            ),
                          );
                        }
                        if (e.message ==
                            'The email address is badly formatted.') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.blue,
                              behavior: SnackBarBehavior.floating,
                              elevation: 1,
                              margin: EdgeInsets.fromLTRB(20, 10, 20, 150),
                              content: Text(
                                "Invalid email format!",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              duration: Duration(seconds: 5),
                            ),
                          );
                        }   
                        // else {
                        //   Navigator.pushReplacementNamed(context, '/login');
                        // }
                        print(e.code);
                        print(e.message);
                        emailTextController.clear();
// show the snackbar here
                      }
                    },
                    child: Text(
                      "Send Request",
                      style: TextStyle(fontSize: 14),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Color(0xff1C1C1C),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: BorderSide(
                            color: Color(0xff1C1C1C),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Want to login?"),
                    SizedBox(width: 07),
                    GestureDetector(
                      child: Text('Login here',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: Colors.blue)),
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
