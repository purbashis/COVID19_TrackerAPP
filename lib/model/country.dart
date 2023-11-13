class CountryCovidData {
  final String countryName;
  final String cases;
  final String totalRecovered;
  final String deaths;
  final String activeCases;
  final String seriousCritical;

  CountryCovidData({
    required this.countryName,
    required this.cases,
    required this.totalRecovered,
    required this.deaths,
    required this.activeCases,
    required this.seriousCritical,
  });
//here we use the fromMap method to convert the map to a CountryCovidData object.
  factory CountryCovidData.fromMap(Map<String, dynamic> map) {
    return CountryCovidData(
      countryName: map['country_name'].toString(),
      cases: map['cases'].toString(),
      totalRecovered: map['total_recovered'].toString(),
      deaths: map['deaths'].toString(),
      activeCases: map['active_cases'].toString(),
      seriousCritical: map['serious_critical'].toString(),
    );
  }
}
