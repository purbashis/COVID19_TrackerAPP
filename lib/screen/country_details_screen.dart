import 'package:covid19/model/country.dart';
import 'package:covid19/widgets/details_box.dart';
import 'package:flutter/material.dart';

class CountryDetailsScreen extends StatefulWidget {
  final CountryCovidData country;
  const CountryDetailsScreen(this.country, {super.key});

  @override
  State<CountryDetailsScreen> createState() => _CountryDetailsScreenState();
}

// Here is the code that will be executed when the country details class is created.
class _CountryDetailsScreenState extends State<CountryDetailsScreen> {
  @override
  // Here is the code that will be executed when the build method is called.
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[10],
        title: Text(
          " Live COVID-19 ${widget.country.countryName} Details",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Here is the code that will be executed when the build method is called.
            Text(
              widget.country.countryName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            // Here is the code that will be executed when the build method is called.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: DetailsBox(
                    title: 'Cases',
                    value: widget.country.cases,
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
                    value: widget.country.activeCases,
                    color: Colors.green,
                  ),
                ),
                Expanded(
                  child: DetailsBox(
                    title: 'Recovered',
                    value: widget.country.totalRecovered,
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
                    value: widget.country.deaths,
                    color: Colors.red,
                  ),
                ),
                Expanded(
                  child: DetailsBox(
                    title: 'Critical',
                    value: widget.country.seriousCritical,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                // Handle button tap
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent[200],
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Text(
                  'back to search',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
