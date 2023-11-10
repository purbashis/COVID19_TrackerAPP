import 'package:flutter/material.dart';

class CountryTab extends StatefulWidget {
  const CountryTab({super.key});

  @override
  State<CountryTab> createState() => _CountryTabState();
}

class _CountryTabState extends State<CountryTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurple[100],
      child: const Center(
        child: Text(
          'Country Tab',
          style: TextStyle(
            fontSize: 30,
            color: Colors.deepPurple,
          ),
        ),
      ),
    );
  }
}
