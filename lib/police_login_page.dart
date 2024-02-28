import 'package:ev_app/police_screen.dart';
import 'package:flutter/material.dart';
import 'package:ev_app/reg_page.dart';

class LoginPagePolice extends StatefulWidget {
  const LoginPagePolice({Key? key}) : super(key: key);

  @override
  LoginPagePoliceState createState() => LoginPagePoliceState();
}

class LoginPagePoliceState extends State<LoginPagePolice> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

  void _loginAsPolice() {
    if (_formKey.currentState!.validate()) {
      // Validation passed, perform login logic
      String username = _usernameController.text;
      String password = _passwordController.text;

      // Perform login logic here (e.g., validate credentials, authenticate user)
      // For simplicity, this example just checks if username and password are not empty

      if (username.isNotEmpty && password.isNotEmpty) {
        // Navigate to the map page if login is successful
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PoliceScreenClass(),
          ),
        );
      } else {
        // Display a SnackBar if username or password is empty (This should not happen if validation is working properly)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An unexpected error occurred. Please try again.'),
          ),
        );
      }
    }
  }
}
