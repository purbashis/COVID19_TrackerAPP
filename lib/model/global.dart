import 'dart:convert';

class Global {
  final String cases; //
  final String deaths;
  final String recovered;
  final String active;
  final String critical; //

  Global({
    required this.cases,
    required this.deaths,
    required this.recovered,
    required this.active,
    required this.critical,
  });

  factory Global.fromMap(Map<String, dynamic> map) {
    return Global(
      cases: map['cases'].toString(),
      active: map['active'].toString(),
      recovered: map['recovered'].toString(),
      deaths: map['deaths'].toString(),
      critical: map['critical'].toString(),
    );
  }

  factory Global.fromJson(String source) =>
      Global.fromMap(json.decode(source) as Map<String, dynamic>);
}
