import 'dart:convert';

class CountryDatabaseModel {

  var id;
  final String? capital;
  final String? pngFlag;
  final String? countryName;
  final String? carSigns;
  final String? carDrivingSide;
  final String languages;
  final String nativeNames;

  CountryDatabaseModel({this.id, required this.capital, required this.pngFlag, required this.countryName, required this.carSigns, required this.carDrivingSide, required this.languages, required this.nativeNames});

  factory CountryDatabaseModel.fromJsonDb(Map<String, dynamic> json) => CountryDatabaseModel(
      capital: json['capital'],
      pngFlag: json['pngFlag'].toString().replaceAll('"', ""),
      countryName: json['countryName'],
      carSigns: json['carSigns'].toString(),
      carDrivingSide: json['carDrivingSide'],
      languages: json['languages'],
      nativeNames: json['nativeNames']);


  Map<String, String?> toJson() {

    var carSignsConverted = jsonEncode(carSigns);
    var languagesMap = jsonEncode(languages);
    var nativeNamesMap = jsonEncode(nativeNames);
    var pngFlagMap = jsonEncode(pngFlag);
    return {
      'capital': capital,
      'pngFlag': pngFlagMap,
      'countryName': countryName,
      'carSigns': carSignsConverted,
      'carDrivingSide': carDrivingSide,
      'languages': languagesMap,
      'nativeNames': nativeNamesMap
    };
  }
}