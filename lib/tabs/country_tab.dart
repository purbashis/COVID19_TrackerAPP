import 'dart:convert';
import 'package:covid19/model/country.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/*
dart:convert: Provides encoding and decoding of JSON.
covid19/model/country.dart: Assuming this is a custom class for representing country data.
flutter/material.dart: Flutter's material design widgets.
http/http.dart as http: For making HTTP requests.

*/

/*
CountryTab Class

A StatefulWidget representing the main tab where country data will be displayed.
*/

class CountryTab extends StatefulWidget {
  const CountryTab({Key? key}) : super(key: key);

  @override
  State<CountryTab> createState() => _CountryTabState();
}

class _CountryTabState extends State<CountryTab> {
/*

getCountryData Function:

A function that makes an HTTP request to get COVID-19 data for countries.

API -  var url = Uri.https(
      'corona-virus-world-and-india-data.p.rapidapi.com',
      '/api',
    );

*/

  Future<List<Country>> getCountryData() async {
    var url = Uri.https(
      'corona-virus-world-and-india-data.p.rapidapi.com',
      '/api',
    );

    var response = await http.get(
      url,
      headers: {
        "X-RapidAPI-Key": "7286094954msha4c7e626ef70588p1f0c0djsn34be9a2b3e0f",
        "X-RapidAPI-Host": "corona-virus-world-and-india-data.p.rapidapi.com",
      },
    );

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      //getting the countries data from the json response as a list of Country objects.

      List<Country> countries = [];

      for (var countryData in jsonData['countries_stat']) {
        Country country = Country(
          countryName: countryData['country_name'].toString(),
          cases: countryData['cases'].toString(),
          totalRecovered: countryData['total_recovered'].toString(),
          deaths: countryData['deaths'].toString(),
          activeCases: countryData['active_cases'].toString(),
          seriousCritical: countryData['serious_critical'].toString(),
        );
        countries.add(country);
      }

      return countries;
    } else {
      throw Exception('Failed to load country data: ${response.statusCode}');
    }
  }

// Here is the scaffold that will be displayed on the screen.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //app bar search field that will be displayed on the top of the screen.
      appBar: AppBar(
        title: const Text('Enter a country name'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              List<Country> countries = await getCountryData();
              showSearch(
                context: context,
                delegate: CountrySearch(countries),
              );
            },
          ),
        ],
      ),

// here is the list view that will display the country data.

      body: FutureBuilder(
        future: getCountryData(),
        builder: (context, snapshot) {
// Here is the code that will be executed when the future is done. if the connection state is done, it will display the list view.

          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Country country = snapshot.data![index];
                return ListTile(
                  title: Text(country.countryName),
                  subtitle: Text('Cases: ${country.cases}'),
//here is the code that will be executed when the list tile is tapped.
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CountryDetails(country),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            // if the connection state is not done, it will display a circular progress indicator.
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
// Here is the search delegate class that will be used to search for countries. we used
// the search delegate class because we want to search for countries and not just for the country name.

class CountrySearch extends SearchDelegate<String> {
  final List<Country> countries;

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
    List<Country> searchResults = countries
        .where((country) =>
            country.countryName.toLowerCase().contains(query.toLowerCase()))
        .toList();
// Here is the code that will be executed when the search is done.
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        Country country = searchResults[index];
        return ListTile(
          title: Text(country.countryName),
          subtitle: Text('Cases: ${country.cases}'),
          //here is the code that will be executed when the list tile is tapped.
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CountryDetails(country),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Here is the code that will be executed when the search is done.
    List<Country> suggestionList = countries
        .where((country) =>
            country.countryName.toLowerCase().contains(query.toLowerCase()))
        .toList();
// Here is the code that will be executed when the search is done.
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        Country country = suggestionList[index];
        return ListTile(
          title: Text(country.countryName),
          subtitle: Text('Cases: ${country.cases}'),
          onTap: () {
            query = country.countryName;
            showResults(context);
          },
        );
      },
    );
  }
}
// Here is the country details class that will be displayed when the list tile is tapped.

class CountryDetails extends StatefulWidget {
  final Country country;
  CountryDetails(this.country);

  @override
  State<CountryDetails> createState() => _CountryDetailsState();
}

// Here is the code that will be executed when the country details class is created.
class _CountryDetailsState extends State<CountryDetails> {
  @override
  // Here is the code that will be executed when the build method is called.
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(
  backgroundColor: Colors.deepPurple[10],
    title: Text(" Live COVID-19 ${widget.country.countryName} Details",
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),),
  ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 200,
          ),

          // Here is the code that will be executed when the build method is called.
          Text(
            widget.country.countryName,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          // Here is the code that will be executed when the build method is called.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child:
                    buildDetailBox('Cases', widget.country.cases, Colors.blue),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: buildDetailBox(
                    'Active', widget.country.activeCases, Colors.green),
              ),
              Expanded(
                child: buildDetailBox(
                    'Recovered', widget.country.totalRecovered, Colors.orange),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child:
                    buildDetailBox('Deaths', widget.country.deaths, Colors.red),
              ),
              Expanded(
                child: buildDetailBox(
                    'Critical', widget.country.seriousCritical, Colors.purple),
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
              child: Text(
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
    );
  }

  Widget buildDetailBox(String title, String value, Color color) {
    //container that will be displayed on the screen.
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
