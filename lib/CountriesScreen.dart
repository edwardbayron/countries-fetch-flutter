import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:vool_test_project/models/CountryDataModel.dart';
import 'package:vool_test_project/widgets/CountryItemWidget.dart';

import 'helpers/Request.dart';
import 'models/CountryListItem.dart';
import 'models/ListItem.dart';

import 'package:http/http.dart' as http;

class CountriesScreen extends StatefulWidget {
  const CountriesScreen({super.key, required this.title});

  final String title;

  @override
  State<CountriesScreen> createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  //late Future<List<CountryDataModel>> futureCountryData;

  // final response = await Request.Post('https://restcountries.com/v3.1/all?fields=name,flag,flags,capital,car,languages', {
  //   'parameters': {
  //     'flags': {'png': },
  //     'area': _selectedGameArea,
  //     'targetRR': _selectedTargetRR,
  //     'hunterRR': _selectedHunterRR,
  //     'maxHunters': _selectedMaxHunters,
  //     'target': 'Me',
  //     'captureProximity': _selectedCaptureProximity,
  //     'entryFee': 0,
  //     'allowBoosters': true,
  //     'allowGuests': true,
  //   },
  //   'geo': {'x': longitude, 'y': latitude },
  // });

  // if (response != null) {
  // final data = response;
  //
  // Notifications.ClaimPlayerTags(data['data']['playerId'].toString());
  // // navigate to previous page
  // Navigator.pop(context);
  // }

  final items = List<CountryListItem>.generate(10,
      (i) => CountryListItem("Estonia", 1, "Tallinn", 10000, "EST", "left"));

  @override
  void initState() {
    futureCountries = fetchCountriesData();
    //futureCountryData = fetchCountries();
  }

  Future<http.Response> requestCountriesData() async {
    final response = await http.get(Uri.parse(
        'https://restcountries.com/v3.1/all?fields=name,flag,flags,capital,car,languages'));
    Logger logger = new Logger();
    var jsonData = jsonDecode(response.body);

    // Log the full JSON response
    //logger.e(jsonEncode(jsonData));  // Logs full JSON
    logger.e(jsonData);
    return response;
  }

  Future<List<CountryModel>> fetchCountriesData() async {
    final response = await http.get(Uri.parse(
        'https://restcountries.com/v3.1/all?fields=name,flag,flags,capital,car,languages'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => CountryModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load countries');
    }
  }

  late Future<List<CountryModel>> futureCountries;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<List<CountryModel>>(
          future: futureCountries,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<CountryModel> countries = snapshot.data!;

              return ListView.builder(
                itemCount: countries.length,
                itemBuilder: (context, index) {
                  CountryModel country = countries[index];
                  return GestureDetector(
                    onTap: () {
                      Logger().e("ON TAP");
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54)),
                      height: 60.0,
                      child: Row(children: [
                        Image.network(
                            width: 20.0,
                            height: 20.0,
                            country.pngFlag ?? 'N/A'),
                        SizedBox(width: 10.0),
                        Text(country.capital ?? 'Unknown Capital'),
                      ]),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//       title: Text(widget.title),
//     ),
//     // body: ListView.builder(
//     //   // Let the ListView know how many items it needs to build.
//     //   itemCount: items.length,
//     //   // Provide a builder function. This is where the magic happens.
//     //   // Convert each item into a widget based on the type of item it is.
//     //   itemBuilder: (context, index) {
//     //
//     //
//     //     final item = items[index];
//     //
//     //     return CountryItemWidget(
//     //       capitalName: item.capitalName,
//     //       image: item.flag,
//     //     );
//     //   },
//     // ),
//     body: Center(
//       child: FutureBuilder<List<CountryDataModel>>(
//         future: futureCountryData,  // Now it's a Future<List<CountryDataModel>>
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             Logger().e("Data loaded");
//
//             // Example: Displaying the first country’s capital
//             return ListView.builder(
//               itemCount: snapshot.data?.length,
//               itemBuilder: (context, index) {
//                 final country = snapshot.data?[index];
//                 return ListTile(
//                   title: Text(snapshot.data?.first.nativeCommonName ?? 'Unknown'),
//                   subtitle: Text('Capital: ${country?.capital?.first.toString() ?? 'N/A'}'),
//                 );
//               },
//             );
//           } else if (snapshot.hasError) {
//             Logger().e("Data errror");
//             return Text('${snapshot.error}');
//           }
//           return const CircularProgressIndicator();
//         },
//       ),
//     ),
//
//     //body: Container(
//     //  child:
//       // child: Column(
//       //   mainAxisAlignment: MainAxisAlignment.center,
//       //   children: <Widget>[
//       //
//       //
//       //
//       //   ],
//       // ),
//     //),
//     // floatingActionButton: FloatingActionButton(
//     //   onPressed: (),
//     //   tooltip: 'Increment',
//     //   child: const Icon(Icons.add),
//     // ),
//   );
// }
