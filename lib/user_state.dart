import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rojgarmela/Jobs/jobs_screen.dart';
import 'package:rojgarmela/LoginPage/login_screen.dart';

class UserState extends StatelessWidget {
  const UserState({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          print("user is not logged in!");
          return const Login();
        } else if (snapshot.hasData) {
          print("user is ALREADY logged in!");
          return const JobScreen();
        } else if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text("An error has been occurred"),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.redAccent,
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: Text("An error has been occurred"),
            ),
          );
        }
      },
    );
  }
}
