import 'dart:convert';

import 'package:covid19/model/country.dart';
import 'package:covid19/screen/country_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CountryTab extends StatefulWidget {
  const CountryTab({Key? key}) : super(key: key);

  @override
  State<CountryTab> createState() => _CountryTabState();
}

class _CountryTabState extends State<CountryTab> {
  List<CountryCovidData> countries = [];

  Future<List<CountryCovidData>> getCountryCovidData() async {
    try {
      var url = Uri.https(
        'corona-virus-world-and-india-data.p.rapidapi.com',
        '/api',
      );
      var response = await http.get(
        url,
        headers: {
          "X-RapidAPI-Key":
              "7286094954msha4c7e626ef70588p1f0c0djsn34be9a2b3e0f",
          "X-RapidAPI-Host": "corona-virus-world-and-india-data.p.rapidapi.com",
        },
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        // print(jsonData);
        //getting the countries data from the json response as a list of CountryCovidData objects.

        for (var countryData in jsonData['countries_stat']) {
          CountryCovidData countryCovidData =
              CountryCovidData.fromMap(countryData);
          countries.add(countryCovidData);
        }

        return countries;
      } else {
        throw Exception('Failed to load country data: ${response.statusCode}');
      }
    } catch (e) {
      return Future.error('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GestureDetector(
            onTap: () async {
              //open search dialog
              showSearch(
                context: context,
                delegate: CountrySearch(countries),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(width: 0.4),
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade100,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Search for the country",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const Icon(Icons.search),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<CountryCovidData>>(
              future: getCountryCovidData(),
              builder: (context, snapshot) {
                // Here is the code that will be executed when the future is done. if the connection state is done, it will display the list view.
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else if (snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("No country found"),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        CountryCovidData countryCovidData =
                            snapshot.data![index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            tileColor: Colors.white,
                            title: Text(countryCovidData.countryName),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Cases: ${countryCovidData.cases}'),
                                Text('Deaths: ${countryCovidData.deaths}')
                              ],
                            ),
                            //here is the code that will be executed when the list tile is tapped.
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CountryDetailsScreen(countryCovidData),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                } else {
                  // if the connection state is not done, it will display a circular progress indicator.
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
// Here is the search delegate class that will be used to search for countries. we used
// the search delegate class because we want to search for countries and not just for the country name.

class CountrySearch extends SearchDelegate<String> {
  final List<CountryCovidData> countries;

  CountrySearch(this.countries);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      // Here is the code that will be executed when the search is cleared.
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      // Here is the code that will be executed when the back button is pressed.
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Here is the code that will be executed when the search is done.
    List<CountryCovidData> searchResults = countries
        .where((countryCovidData) => countryCovidData.countryName
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();
// Here is the code that will be executed when the search is done.
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        CountryCovidData countryCovidData = searchResults[index];
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              tileColor: Colors.white,

              title: Text(countryCovidData.countryName),
              subtitle: Text('Cases: ${countryCovidData.cases}'),
              //here is the code that will be executed when the list tile is tapped.
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CountryDetailsScreen(countryCovidData),
                  ),
                );
              },
            ));
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Here is the code that will be executed when the search is done.
    List<CountryCovidData> suggestionList = countries
        .where((countryCovidData) => countryCovidData.countryName
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();
// Here is the code that will be executed when the search is done.
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        CountryCovidData countryCovidData = suggestionList[index];
        return ListTile(
          title: Text(countryCovidData.countryName),
          subtitle: Text('Cases: ${countryCovidData.cases}'),
          onTap: () {
            query = countryCovidData.countryName;
            showResults(context);
          },
        );
      },
    );
  }
}
// Here is the country details class that will be displayed when the list tile is tapped.

