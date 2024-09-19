// class CountryDataModel {
//   final String pngFlag;
//   final String svgFlag;
//   final String altFlagText;
//   final String common;
//   final String officialName;
//   final String? nativeCommonName;
//   final String? nativeOfficialName;
//   final List<dynamic> capital;
//   final String language;
//   final String flagEmoji;
//   final String carSign;
//   final String driveSide;
//
//   const CountryDataModel({
//     required this.pngFlag,
//     required this.svgFlag,
//     required this.altFlagText,
//     required this.common,
//     required this.officialName,
//     required this.nativeCommonName,
//     required this.nativeOfficialName,
//     required this.capital,
//     required this.language,
//     required this.flagEmoji,
//     required this.carSign,
//     required this.driveSide,
//   });
//
//   factory CountryDataModel.fromJson(dynamic json) {
//     return CountryDataModel(
//       pngFlag: json['flags']['png'] as String,
//       svgFlag: json['flags']['svg'] as String,
//       altFlagText: json['flags']['alt'] as String? ?? '',
//       common: json['name']?['common'] as String ?? '',
//       officialName: json['name']['official'] as String,
//       nativeCommonName: json['name']['nativeName']['eng']?['common'],
//       nativeOfficialName: json['name']?['nativeName']?['eng']?['official'] ?? 'test',
//       capital: (json['capital']),
//       language: json['languages']['eng'] ?? 'testLanguage',
//       flagEmoji: json['flag'] ?? 'testFlagEmoji',
//       carSign: json['car']['signs'][0] ?? 'testCarSign',
//       driveSide: json['car']['side'] ?? 'testDriveSide',
//     );
//   }
// }

import 'dart:convert';

import 'package:logger/logger.dart';

class CountryModel {

  var id;
  final String? capital;
  final String? pngFlag;
  final String? countryName;
  final List<dynamic>? carSigns;
  final String? carDrivingSide;
  final Map<String, dynamic>? languages;
  final Map<String, dynamic>? nativeNames;

  CountryModel({this.id, required this.capital, required this.pngFlag, required this.countryName, required this.carSigns, required this.carDrivingSide, required this.languages, required this.nativeNames});

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      capital: json['capital'] != null && (json['capital']).isNotEmpty ? json['capital'][0] : 'N/A',
      pngFlag: json['flags']?['png'] as String?,
      countryName: json['name']?['common'] as String?,
      carSigns: json['car']?['signs'],
      carDrivingSide: json['car']?['side'] as String?,
      languages: convertLanguageMap(json['languages']),
      nativeNames: json['name']?['nativeName']
    );
  }


  factory CountryModel.fromJsonV2(Map<String, dynamic> json) {
    return CountryModel(
        capital: json['capital'] ?? 'Unknown Capital',
        pngFlag: json['pngFlag'] ?? 'https://placeholder.com/flag.png',
        countryName: json['name']?['common'] ?? "Unknown Country",
        carSigns: json['car']?['signs'],
        carDrivingSide: json['car']?['side'] as String?,
        languages: json['languages'],
        nativeNames: json['name']?['nativeName'] as Map<String, dynamic>?

    );
  }



  Map<String, String?> toJson() {

    var carSignsConverted = carSigns?.join(" ");
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

  List<String> getNativeCodes(CountryModel country) {
    List<String> commonNames = [];

    if (country.languages != null && country.nativeNames != null) {
      country.languages!.forEach((key, value) {
        // If nativeNames contains the key from languages, extract its 'common' value
        if (country.nativeNames!.containsKey(key)) {
          commonNames.add(key);
        }
      });
    }
    for(var i in commonNames){
    }
    return commonNames;  // Join them into a single string for displaying
  }

  String getNativeCommonNames(CountryModel country) {
    List<String> commonNames = [];

    if (country.languages != null && country.nativeNames != null) {
      country.languages!.forEach((key, value) {
        // If nativeNames contains the key from languages, extract its 'common' value
        if (country.nativeNames!.containsKey(key)) {
          commonNames.add(country.nativeNames![key]['common']);
        }
      });
    }

    return commonNames.join(', ');  // Join them into a single string for displaying
  }

  Map<String, Object?> toMap() {
    return {
      'capital': capital,
      'pngFlag': pngFlag,
      'countryName': countryName,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Country{capital: $capital, pngFlag: $pngFlag, countryName: $countryName}';
  }



  CountryModel copy({
    int? id,
    String? capital,
    String? pngFlag,
    String? countryName,
    List<dynamic>? carSigns,
    String? carDrivingSide,
    Map<String, dynamic>? languages,
    Map<String, dynamic>? nativeNames,
  }) =>
      CountryModel(
        id: id ?? this.id,
        capital: capital ?? this.capital,
        pngFlag: pngFlag ?? this.pngFlag,
        countryName: countryName ?? this.countryName,
        carSigns: carSigns ?? this.carSigns,
        carDrivingSide: carDrivingSide ?? this.carDrivingSide,
        languages: languages ?? this.languages,
        nativeNames: nativeNames ?? this.nativeNames,
      );

}

Map<String, dynamic> convertLanguageMap(dynamic languageData) {
  if (languageData is Map<String, dynamic>) {
    return languageData;
  } else if (languageData is Map) {
    return languageData.map((key, value) => MapEntry(key.toString(), value));
  } else if (languageData is String) {
    try {
      var decoded = jsonDecode(languageData);
      if (decoded is Map) {
        return decoded.map((key, value) => MapEntry(key.toString(), value));
      }
    } catch (e) {
      print("Error parsing language data: $e");
    }
  }

  // If all else fails, return an empty map
  return {};
}