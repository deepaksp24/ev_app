import 'package:ev_app/police_screen.dart';
import 'package:flutter/material.dart';

class PoliceNotify extends StatelessWidget {
  const PoliceNotify({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'notification',
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Police screen"),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 203, 99, 30),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(child: Text("notification screen")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PoliceScreenClass(),
                    ),
                  );
                },
                child: Text("map page"))
          ],
        ),
      ),
    );
  }
}
