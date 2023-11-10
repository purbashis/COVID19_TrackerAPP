import 'package:flutter/material.dart';

class GlobalTab extends StatefulWidget {
  const GlobalTab({super.key});

  @override
  State<GlobalTab> createState() => _GlobalTabState();
}

class _GlobalTabState extends State<GlobalTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 196, 233, 207),
      child: const Center(
        child: Text(
          'Global Tab',
          style: TextStyle(
            fontSize: 30,
            color: Colors.deepPurple,
          ),
        ),
      ),
    );
  }
}
