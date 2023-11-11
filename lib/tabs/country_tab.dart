import 'dart:convert';
import 'package:covid19/model/country.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CountryTab extends StatefulWidget {
  const CountryTab({Key? key}) : super(key: key);

  @override
  State<CountryTab> createState() => _CountryTabState();
}

class _CountryTabState extends State<CountryTab> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Covid19 Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              // Call the method to get country data
              List<Country> countries = await getCountryData();
              showSearch(
                context: context,
                delegate: CountrySearch(countries),
              );
            },
          ),
        ],
      ),
      body: Center(
        
        child: ElevatedButton(
          onPressed: () async {
            // Example usage of getCountryData
            List<Country> countries = await getCountryData();
            // Do something with the country data, e.g., display in a list
            print(countries);
          },
          child: const Text('Load Country Data'),
        ),
        
      ),
      
    );
  }
}

class CountrySearch extends SearchDelegate<String> {
  final List<Country> countries;

  CountrySearch(this.countries);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
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
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implement search results based on the query
    List<Country> searchResults = countries
        .where((country) =>
            country.countryName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        Country country = searchResults[index];
        return ListTile(
          title: Text(country.countryName),
          subtitle: Text('Cases: ${country.cases}'),
          onTap: () {
            // Handle tap on the search result
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
    // Implement suggestions based on the query
    List<Country> suggestionList = countries
        .where((country) =>
            country.countryName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        Country country = suggestionList[index];
        return ListTile(
          title: Text(country.countryName),
          subtitle: Text('Cases: ${country.cases}'),
          onTap: () {
            // Handle tap on the suggestion
            // For example, update the UI with the selected suggestion
            query = country.countryName;
            showResults(context);
          },
        );
      },
    );
  }
}













class CountryDetails extends StatelessWidget {
  final Country country;

  CountryDetails(this.country);

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(country.countryName),
    //   ),
    //   body: Padding(

    //     padding: const EdgeInsets.all(16.0),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         buildDetailBox('Cases', country.cases),
    //         buildDetailBox('Total Recovered', country.totalRecovered),
    //         buildDetailBox('Deaths', country.deaths),
    //         buildDetailBox('Active Cases', country.activeCases),
    //         buildDetailBox('Serious Critical', country.seriousCritical),
    //       ],
    //     ),
    //   ),
    // );

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              country.countryName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 70,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: buildDetailBox('Cases', country.cases, Colors.blue),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: buildDetailBox(
                    'Active Cases', country.activeCases, Colors.green),
              ),
              Expanded(
                child: buildDetailBox(
                    'Total Recovered', country.totalRecovered, Colors.orange),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: buildDetailBox('Deaths', country.deaths, Colors.red),
              ),
              Expanded(
                child: buildDetailBox(
                    'Serious Critical', country.seriousCritical, Colors.purple),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDetailBox(String title, String value, Color color) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
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
