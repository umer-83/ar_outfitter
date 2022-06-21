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
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Reset Password'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 70, 0, 0),
            child: Column(
              children: [
                TextFormField(
                  controller: emailTextController,
                  obscureText: false,
                  enableSuggestions: !false,
                  autocorrect: !false,
                  style: TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(color: Colors.blue, width: 2)),
                      contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.mail),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2))),
                ),
                SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                      onPressed: () async {
                        try {
                          await auth.sendPasswordResetEmail(
                              email: emailTextController.text);
                        } on FirebaseAuthException catch (e) {
                          if (e.message ==
                              'There is no user record corresponding to this identifier. The user may have been deleted.') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text("Invalid e-mail address."),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                          if (e.message == 'Given String is empty or null.') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text("Invalid e-mail address."),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                          if (e.message ==
                              'The email address is badly formatted.') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text("Invalid e-mail address."),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          } else {
                            Navigator.pushReplacementNamed(context, '/login');
                          }
                          print(e.code);
                          print(e.message);
// show the snackbar here
                        }
                      },
                      child: Text(
                        "Send Request",
                        style: TextStyle(fontSize: 14),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                  side: BorderSide(color: Colors.blue))))),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  child: Text('Login here',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.blue)),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
