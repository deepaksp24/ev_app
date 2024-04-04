import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ev_app/map_page.dart'; // Assuming this is your map page
import 'package:ev_app/reg_page.dart'; // Assuming this is your registration page
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance; // Initialize Firebase Auth
  String? _deviceToken;

  @override
  void initState() {
    super.initState();
    _getDeviceToken(); // Fetch the device token on app launch
  }

  Future<void> _getDeviceToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    _deviceToken = await messaging.getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
                  labelText: 'Username (Email)', // Use email for username
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address';
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
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String email = _usernameController.text;
                    String password = _passwordController.text;

                    try {
                      UserCredential userCredential =
                          await _auth.signInWithEmailAndPassword(
                              email: email, password: password);

                      // Check user type after successful login
                      DocumentSnapshot userSnapshot = await FirebaseFirestore
                          .instance
                          .collection('users')
                          .doc(userCredential.user!.uid)
                          .get();

                      if (userSnapshot.exists) {
                        String userType = userSnapshot.get('user_type');
                        if (userType == 'Ambulance Driver') {
                          if (_deviceToken != null) {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(userCredential.user!.uid)
                                .update({
                              'device_token': _deviceToken,
                            });
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MapperClass(),
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
                },
                child: const Text('Login'),
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
}
