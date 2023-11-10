import 'dart:convert';
import 'package:covid19/model/Global.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GlobalTab extends StatefulWidget {
  const GlobalTab({Key? key}) : super(key: key);

  @override
  State<GlobalTab> createState() => _GlobalTabState();
}

class _GlobalTabState extends State<GlobalTab> {
  List<Global> global = [];

  Future<void> getTeams() async {
    var response = await http.get(Uri.https('disease.sh', 'v3/covid-19/all'));
    var jsonData = jsonDecode(response.body);

    final team = Global(
      cases: jsonData['cases'].toString(),
      active: jsonData['active'].toString(),
      recovered: jsonData['recovered'].toString(),
      deaths: jsonData['deaths'].toString(),
      critical: jsonData['critical'].toString(),
    );

    global.add(team);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: getTeams(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Scaffold(
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Global COVID Report',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 70,
                    ),
                   
                         Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child:  buildDataBox(
                              'Cases', global[0].cases, Colors.blue),
                        ),
                      
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: buildDataBox(
                              'Active', global[0].active, Colors.green),
                        ),
                        Expanded(
                          child: buildDataBox(
                              'Recovered', global[0].recovered, Colors.orange),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: buildDataBox(
                              'Deaths', global[0].deaths, Colors.red),
                        ),
                        Expanded(
                          child: buildDataBox(
                              'Critical', global[0].critical, Colors.purple),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget buildDataBox(String title, String value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '$title',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
