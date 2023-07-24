import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rojgarmela/user_state.dart';
import 'package:rojgarmela/widgets/bottom_nav_bar.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(
        index: 0,
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Jobs Screen',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.indigo.shade300,
      ),
      // body: ElevatedButton(
      //     style: ButtonStyle(
      //         backgroundColor: MaterialStateProperty.all(Colors.green)),
      //     onPressed: () {
      // _firebaseAuth.signOut();
      // Navigator.canPop(context) ? Navigator.pop(context) : null;
      // Navigator.pushReplacement(
      //     context,
      //     CupertinoPageRoute(
      //       builder: (context) => const UserState(),
      //     ));
      //     },
      //     child: const Text(
      //       "Logout",
      //       style: TextStyle(color: Colors.black),
      //     )),
    );
  }
}
