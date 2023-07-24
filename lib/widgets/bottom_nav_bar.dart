// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:rojgarmela/Jobs/jobs_screen.dart';
import 'package:rojgarmela/Jobs/upload_job.dart';
import 'package:rojgarmela/LoginPage/login_screen.dart';
import 'package:rojgarmela/Services/global_methods.dart';
import 'package:rojgarmela/search/profile_company.dart';
import 'package:rojgarmela/search/search_companies.dart';
import 'package:rojgarmela/user_state.dart';

class BottomNavBar extends StatelessWidget {
  int index;
  BottomNavBar({
    Key? key,
    required this.index,
  }) : super(key: key);
  logout(BuildContext context) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black54,
        title: const Row(
          children: [
            Icon(
              Icons.logout,
              color: Colors.white,
            ),
            Text('Signout', style: TextStyle(color: Colors.white))
          ],
        ),
        content: const Text("Do you really wanna logout?",
            style: TextStyle(color: Colors.white, fontSize: 20)),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'No',
                style: TextStyle(color: Colors.green, fontSize: 18),
              )),
          TextButton(
              onPressed: () {
                firebaseAuth.signOut();
                Navigator.canPop(context) ? Navigator.pop(context) : null;
                Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const UserState(),
                    ));
              },
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.green, fontSize: 18),
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      animationDuration: const Duration(seconds: 300),
      animationCurve: Curves.bounceIn,
      color: Colors.deepOrange.shade400,
      height: GlobalMethod.height(context) * 0.08,
      index: index,
      onTap: (index) {
        if (index == 0) {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) => const JobScreen(),
              ));
        } else if (index == 1) {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) => const AllWorkersScreen(),
              ));
        } else if (index == 2) {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) => const UploadJob(),
              ));
        } else if (index == 3) {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) => const ProfileScreen(),
              ));
        } else if (index == 4) {
          logout(context);
        }
      },
      items: const [
        Icon(
          Icons.list,
          size: 19,
          color: Colors.black,
        ),
        Icon(
          Icons.search,
          size: 19,
          color: Colors.black,
        ),
        Icon(
          Icons.upload,
          size: 19,
          color: Colors.black,
        ),
        Icon(
          Icons.person_pin,
          size: 19,
          color: Colors.black,
        ),
        Icon(
          Icons.exit_to_app,
          size: 19,
          color: Colors.black,
        ),
      ],
    );
  }
}
