import 'package:flutter/material.dart';
import 'package:rojgarmela/widgets/bottom_nav_bar.dart';

class AllWorkersScreen extends StatefulWidget {
  const AllWorkersScreen({super.key});

  @override
  State<AllWorkersScreen> createState() => _AllWorkersScreenState();
}

class _AllWorkersScreenState extends State<AllWorkersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'All Workers Screen',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.indigo,
      ),
      bottomNavigationBar: BottomNavBar(index: 1),
    );
  }
}
