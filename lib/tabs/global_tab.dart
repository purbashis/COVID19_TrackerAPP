import 'package:covid19/model/global.dart';
import 'package:covid19/widgets/details_box.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GlobalTab extends StatefulWidget {
  const GlobalTab({Key? key}) : super(key: key);

  @override
  State<GlobalTab> createState() => _GlobalTabState();
}
//
class _GlobalTabState extends State<GlobalTab> {

  //getting the global data from the API.
  Future<Global> getGlobalCovidReport() async {
    var response = await http.get(Uri.https('disease.sh', 'v3/covid-19/all'));
    return Global.fromJson(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<Global>(
          future: getGlobalCovidReport(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final globaldata = snapshot.data;
              if (globaldata == null) {
                return const Center(
                  child: Text("Unable to get data"),
                );
              } else {
                return Scaffold(
                  //here we are displaying the global data on the screen.
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Global COVID Report',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: DetailsBox(
                              title: 'Cases',
                              value: globaldata.cases,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: DetailsBox(
                              title: 'Active',
                              value: globaldata.active,
                              color: Colors.green,
                            ),
                          ),
                          Expanded(
                            child: DetailsBox(
                              title: 'Recovered',
                              value: globaldata.recovered,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: DetailsBox(
                              title: 'Deaths',
                              value: globaldata.deaths,
                              color: Colors.red,
                            ),
                          ),
                          Expanded(
                            child: DetailsBox(
                              title: 'Critical',
                              value: globaldata.critical,
                              color: Colors.purple,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
