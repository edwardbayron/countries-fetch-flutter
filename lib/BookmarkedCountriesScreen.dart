import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vool_test_project/CountryDetailsScreen.dart';
import 'package:vool_test_project/models/CountryDataModel.dart';


import 'package:http/http.dart' as http;

class BookmarkedCountriesScreen extends StatefulWidget {
  const BookmarkedCountriesScreen({super.key});


  @override
  State<BookmarkedCountriesScreen> createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<BookmarkedCountriesScreen> {

  Set<String> bookmarkedCountries = Set();
  List<CountryModel> allCountries = []; // To store all countries initially
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
        bookmarkedCountries = savedBookmarks.toSet();
        bookmarkedCountriesList = allCountries
            .where((country) => bookmarkedCountries.contains(country.capital))
            .toList();
        Logger().e("test: "+bookmarkedCountriesList.length.toString());
      });
    }
  }


  late Future<List<CountryModel>> futureCountries;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bookmarks"),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          CountryModel country = bookmarkedCountriesList[index];

          return GestureDetector(
            onTap: () {
              showDialog(context: context, builder: (BuildContext context) {
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
                  Image.asset(
                    width: 20.0,
                    height: 20.0,
                    'assets/images/bookmark_filled.png', // Display filled bookmark
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

