import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vool_test_project/CountryDetailsScreen.dart';
import 'package:vool_test_project/models/CountryDataModel.dart';

List<CountryModel> bookmarkedCountriesList = [];

class BookmarkedCountriesScreen extends StatefulWidget {
  const BookmarkedCountriesScreen({super.key});

  @override
  State<BookmarkedCountriesScreen> createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<BookmarkedCountriesScreen> {

  Set<String> bookmarkedCountriesJson = Set();

  @override
  void initState() {
    super.initState();
    loadBookmarksSync();
  }

  List<CountryModel> getBookmarkedCountries() {
    return bookmarkedCountriesList; // Accessing the globally stored data synchronously
  }

  // Future<List<CountryModel>> getBookmarkedCountries() async {
  //   // Check if there are any saved bookmarks before proceeding
  //   if (bookmarkedCountriesJson.isEmpty) {
  //     Logger().e("No bookmarks found in set.");
  //     return [];
  //   }
  //
  //   // Map over the bookmarked JSON strings, decode them, and convert into CountryModel
  //   List<CountryModel> countriesList = bookmarkedCountriesJson.map((countryJson) {
  //     Map<String, dynamic> json = jsonDecode(countryJson);
  //     Logger().e("Decoded JSON: $json"); // Debugging output
  //
  //     return CountryModel.fromJson(json);
  //   }).toList();
  //
  //   return Future.value(countriesList);
  // }

  // Future<void> loadBookmarks() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String>? savedBookmarks = prefs.getStringList('bookmarkedCountries');
  //   Logger().e("YOLO SAVED BOOKMARKS: " + savedBookmarks.toString());
  //
  //   for(var item in savedBookmarks!){
  //     Logger().e("YOLO SAVED BOOKMARKS countries 5: " + item);
  //   }
  //
  //
  //   if (savedBookmarks != null) {
  //     setState(() {
  //       bookmarkedCountriesJson = savedBookmarks.toSet();
  //       bookmarkedCountriesList = getBookmarkedCountries(); // Initialize the future here
  //     });
  //   }
  //   // else {
  //   //   setState(() {
  //   //     bookmarkedCountriesList = Future.value([]); // If no bookmarks, return an empty list
  //   //   });
  //   // }
  //
  //   //setState(() {
  //
  //   //});
  // }



  @override
  Widget build(BuildContext context) {
    List<CountryModel> countries = getBookmarkedCountries();

    return Scaffold(
        appBar: AppBar(
          title: Text("Bookmarks Screen"),
        ),
        body: countries.isNotEmpty
            ? ListView.builder(

          itemCount: countries.length,
          itemBuilder: (context, index) {
            CountryModel country = countries[index];
            Logger()
                .e("COUNTRY: png: " + country.pngFlag.toString());
            Logger().e(
                "COUNTRY: capital: " +
                    country.capital.toString());
            return GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CountryDetailsScreen(model: country);
                    });
              },
              child: Container(
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54)),
                height: 60.0,
                child: Row(
                  children: [
                    Image.network(
                      width: 20.0,
                      height: 20.0,
                      country.pngFlag ?? 'N/A',
                    ),
                    SizedBox(width: 10.0),
                    Text(country.capital ?? 'Unknown Capital'),
                    Expanded(child: SizedBox()),
                  ],
                ),
              ),
            );
          }


        ) : const Text('No bookmarks found')) ;
  }

  }


void loadBookmarksSync() {
  SharedPreferences.getInstance().then((prefs) {
    List<String>? savedBookmarks = prefs.getStringList('bookmarkedCountries');
    if (savedBookmarks != null) {
      bookmarkedCountriesList = savedBookmarks.map((countryJson) {
        Map<String, dynamic> data = jsonDecode(countryJson);

        Logger().e("test yolo: "+data['pngFlag']);
        // Handle the languages field
        if (data['languages'] is String) {
          data['languages'] = jsonDecode(data['languages']);
        }

        if (data['pngFlag'] is String) {
          data['pngFlag'] = "https://flagcdn.com/w320/gs.png";
        }

        // Handle the nativeNames field
        if (data['commonNames'] is String) {
          data['name'] = {'nativeName': jsonDecode(data['commonNames'])};
          data.remove('commonNames');
        }

        return CountryModel.fromJsonV2(data);
      }).toList();

    }
  });
}