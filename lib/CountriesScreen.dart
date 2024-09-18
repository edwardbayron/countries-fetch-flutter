import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vool_test_project/BookmarkedCountriesScreen.dart';
import 'package:vool_test_project/CountryDatabaseModel.dart';
import 'package:vool_test_project/CountryDetailsScreen.dart';
import 'package:vool_test_project/models/CountryDataModel.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as join;

import 'DB.dart';

class CountriesScreen extends StatefulWidget {
  const CountriesScreen({super.key});

  @override
  State<CountriesScreen> createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {

  Set<String> bookmarkedCountriesJson = Set();
  late Future<List<CountryModel>> futureCountries;
  DB database = DB.instance;

  @override
  void initState() {

    futureCountries = fetchCountriesData();
    //loadBookmarks();


  }

  Future<List<CountryModel>> fetchCountriesData() async {
    final response = await http.get(Uri.parse(
        'https://restcountries.com/v3.1/all?fields=name,flag,flags,capital,car,languages'));

    if (response.statusCode == 200) {
      Logger().e("COUNTRIES SCREEN YOLO SAVED BOOKMARKS 3: " + response.body);
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => CountryModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load countries');
    }
  }

  Future<void> saveBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('bookmarkedCountries', bookmarkedCountriesJson.toList());
  }

  Future<void> loadBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedBookmarks = prefs.getStringList('bookmarkedCountries');
    if (savedBookmarks != null) {
      setState(() {
        bookmarkedCountriesJson = savedBookmarks.toSet();
      });
    }
  }

  void openBookmarks() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BookmarkedCountriesScreen()),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Countries Screen"),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(onPressed: () => {}, icon: Icon(Icons.search)),
          IconButton(onPressed: () => {
            openBookmarks()
          }, icon: Icon(Icons.bookmark)),
        ],
      ),
      body: Center(
        child: FutureBuilder<List<CountryModel>>(
          future: futureCountries,
          builder: (context, snapshot) {
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  elevation: 12.0,
                  textStyle: const TextStyle(color: Colors.yellow)),
              child: const Text('Bookmarked Countries'),
            );
            if (snapshot.hasData) {
              List<CountryModel> countries = snapshot.data!;

              return ListView.builder(
                itemCount: countries.length,
                itemBuilder: (context, index) {
                  CountryModel country = countries[index];
                  bool isBookmarked = bookmarkedCountriesJson.contains(jsonEncode(country.toJson()));
                  return GestureDetector(
                    onTap: () {
                      showDialog(context: context, builder: (BuildContext context){
                        return CountryDetailsScreen(model: country, dbModel: CountryDatabaseModel(
                            capital: '',
                            pngFlag: '',
                            countryName: '',
                            carSigns: '',
                            carDrivingSide: '',
                            languages: '',
                            nativeNames: ''));
                      });
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
                        Expanded(child: SizedBox()),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              String countryJson = jsonEncode(country);
                              if (isBookmarked) {
                                //bookmarkedCountriesJson.remove(countryJson);
                                database.delete(country.capital!);
                              } else {
                                //bookmarkedCountriesJson.add(countryJson);
                                Logger().e("TEST: country png: "+country.pngFlag.toString());
                                database.create(country);
                              }
                            });
                            //database.create(country);
                            //saveBookmarks();
                          },
                          child: Image.asset(
                            width: 20.0,
                            height: 20.0,
                            isBookmarked
                                ? 'assets/images/bookmark_filled.png'
                                : 'assets/images/bookmark.png',
                          ),
                        ),
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
