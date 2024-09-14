import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
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





  final items = List<CountryListItem>.generate(
    10,
        (i) => CountryListItem("Estonia", 1, "Tallinn", 10000, "EST", "left")
  );


  Future<http.Response> requestCountriesData() async {
    final response = await http.get(Uri.parse('https://restcountries.com/v3.1/all?fields=name,flag,flags,capital,car,languages'));
    Logger logger = new Logger();
    var jsonData = jsonDecode(response.body);

    // Log the full JSON response
    //logger.e(jsonEncode(jsonData));  // Logs full JSON
    logger.e(jsonData);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    Logger elogger = new Logger();
    elogger.d(requestCountriesData());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        // Let the ListView know how many items it needs to build.
        itemCount: items.length,
        // Provide a builder function. This is where the magic happens.
        // Convert each item into a widget based on the type of item it is.
        itemBuilder: (context, index) {


          final item = items[index];

          return CountryItemWidget(
            capitalName: item.capitalName,
            image: item.flag,
          );
        },
      ),

      //body: Container(
      //  child:
        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: <Widget>[
        //
        //
        //
        //   ],
        // ),
      //),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (),
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}