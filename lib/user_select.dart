import 'package:ev_app/login_page.dart';
import 'package:ev_app/police_login_page.dart';
import 'package:ev_app/reg_page.dart';
import 'package:flutter/material.dart';

class UserSelect extends StatelessWidget {
  const UserSelect({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("emergancy vechicle app"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Select the User Type",
                style: TextStyle(fontSize: 25),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 120,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    _loginDriver(context);
                  },
                  child: const Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Center the elements
                    children: [
                      Icon(Icons.drive_eta_outlined), // Add the icon
                      SizedBox(
                          width: 5), // Add some spacing between icon and text
                      Text("Driver"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 120,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    _loginPolice(context);
                  },
                  child: const Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Center the elements
                    children: [
                      Icon(Icons.local_police_outlined), // Add the icon
                      SizedBox(
                          width: 5), // Add some spacing between icon and text
                      Text("Police"),
                    ],
                  ),
                ),
              ),
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
        ));
  }
}

void _loginDriver(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const LoginPage(),
    ),
  );
}

void _loginPolice(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const LoginPagePolice(),
    ),
  );
}
