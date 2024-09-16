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

class CountryModel {

  final String? capital;
  final String? pngFlag;

  CountryModel({required this.capital, required this.pngFlag});

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      capital: json['capital'] != null && (json['capital']).isNotEmpty ? json['capital'][0] : 'N/A',
      pngFlag: json['flags']?['png'] as String?,
    );
  }

  factory CountryModel.fromJsonV2(Map<String, dynamic> json) {
    return CountryModel(
      capital: json['capital'] ?? 'Unknown Capital',
      pngFlag: json['pngFlag'] ?? 'https://placeholder.com/flag.png',
    );
  }

  Map<String, String?> toJson() {
    return {
      'capital': capital,
      'pngFlag': pngFlag,

    };
  }
}