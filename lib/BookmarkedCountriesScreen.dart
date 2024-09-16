import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vool_test_project/CountryDetailsScreen.dart';
import 'package:vool_test_project/models/CountryDataModel.dart';

class BookmarkedCountriesScreen extends StatefulWidget {
  const BookmarkedCountriesScreen({super.key});

  @override
  State<BookmarkedCountriesScreen> createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<BookmarkedCountriesScreen> {
  List<CountryModel> bookmarkedCountriesList = [];

  @override
  void initState() {
    loadBookmarks();
  }

  Future<void> loadBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedBookmarks = prefs.getStringList('bookmarkedCountries');
    if (savedBookmarks != null) {
      setState(() {
        Logger().e("YOLO: 1: " + savedBookmarks.first);

        // bookmarkedCountriesList = savedBookmarks.map((countryJson) {
        //   Logger().e("Decoded JSON: $countryJson");
        //   return CountryModel.fromJson(jsonDecode(countryJson));
        // }).toList();

        List<dynamic> data = jsonDecode(savedBookmarks.toString());
        bookmarkedCountriesList = data.map((json) => CountryModel.fromJsonV2(json)).toList();

        for(var item in savedBookmarks){
          Logger().e("item: "+item);
          //Logger().e("item list: "+CountryModel.fromJson(jsonDecode(item)));
        }

      });
    }
  }

  Future<void> saveBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> bookmarkedCountriesJson = bookmarkedCountriesList
        .map((country) => jsonEncode(country.toJson()))
        .toList();
    prefs.setStringList('bookmarkedCountries', bookmarkedCountriesJson);
  }

  late Future<List<CountryModel>> futureCountries;

  @override
  Widget build(BuildContext context) {
    Logger().e("Test length: " + bookmarkedCountriesList.length.toString());
    Logger().e("Test length: " + bookmarkedCountriesList.length.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("Bookmarks Screen"),
      ),
      body: ListView.builder(
        itemCount: bookmarkedCountriesList.length,
        itemBuilder: (context, index) {
          Logger().e("YOLO: 2 capital: " +
              bookmarkedCountriesList.first.capital.toString());
          Logger().e("YOLO: 2 png: " +
              bookmarkedCountriesList.first.pngFlag.toString());
          CountryModel country = bookmarkedCountriesList[index];
          Logger().e("COUNTRY: png: " + country.pngFlag.toString());
          Logger().e("COUNTRY: capital: " + country.capital.toString());
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
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black54)),
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
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // Unbookmark logic
                        bookmarkedCountriesList.removeAt(index);
                      });
                      saveBookmarks(); // Save updated bookmarks
                    },
                    child: Image.asset(
                      width: 20.0,
                      height: 20.0,
                      'assets/images/bookmark_filled.png', // Filled bookmark
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
