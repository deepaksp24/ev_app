// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_app/police_notify_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ev_app/reg_page.dart';
import 'package:ev_app/global_variable.dart';

class LoginPagePolice extends StatefulWidget {
  const LoginPagePolice({Key? key}) : super(key: key);

  @override
  LoginPagePoliceState createState() => LoginPagePoliceState();
}

class LoginPagePoliceState extends State<LoginPagePolice> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _deviceToken;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    _getDeviceToken(); // Fetch the device token on app launch
  }

  Future<void> _getDeviceToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    _deviceToken = await messaging.getToken();
    usertoken = _deviceToken;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login As police'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'User Login',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  _loginAsPolice();
                },
                child: const Text('Login as police'),
              ),
              const SizedBox(height: 10.0),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegistrationPage(),
                    ),
                  );
                },
                child: const Text('New User? Register'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loginAsPolice() async {
    if (_formKey.currentState!.validate()) {
      String email = _usernameController.text;
      String password = _passwordController.text;

      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        // Check user type after successful login
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (userSnapshot.exists) {
          String userType = userSnapshot.get('user_type');
          if (userType == 'Traffic Police') {
            if (_deviceToken != null) {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(userCredential.user!.uid)
                  .update({
                'device_token': _deviceToken,
              });
            }
            globalUserId = userCredential.user!.uid;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PoliceNotify(),
              ),
            );
          } else {
            // Handle non-user login attempts securely
            // (Avoid granting unauthorized access or impersonating officials)
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'This account type is not authorized for this application.'),
              ),
            );
            // Consider logging out the user or redirecting to a different page
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Invalid email or password.',
              ),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid email or password.'),
            ),
          );
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that email.');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid email or password.'),
            ),
          );
        } else {
          print(e.code);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('An unexpected error occurred.'),
            ),
          );
        }
      }
    }
  }
}
