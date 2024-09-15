import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vool_test_project/BookmarkedCountriesScreen.dart';
import 'package:vool_test_project/CountryDetailsScreen.dart';
import 'package:vool_test_project/models/CountryDataModel.dart';

import 'models/CountryListItem.dart';

import 'package:http/http.dart' as http;

class CountriesScreen extends StatefulWidget {
  const CountriesScreen({super.key, required this.title});

  final String title;

  @override
  State<CountriesScreen> createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {

  final items = List<CountryListItem>.generate(10,
      (i) => CountryListItem("Estonia", 1, "Tallinn", 10000, "EST", "left"));

  Set<String> bookmarkedCountriesJson = Set();

  @override
  void initState() {

    futureCountries = fetchCountriesData();
    loadBookmarks();  // Load bookmarks when screen initialize
    // s
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

  // Function to save bookmarks
  Future<void> saveBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('bookmarkedCountries', bookmarkedCountriesJson.toList());
  }

// Function to load bookmarks on app start
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
              // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),
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
                      Logger().e("ON TAP: country: "+country.capital.toString());
                      Logger().e("ON TAP: index: "+index.toString());
                      showDialog(context: context, builder: (BuildContext context){
                        return CountryDetailsScreen(model: country);
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
                              String countryJson = jsonEncode(country.toJson());
                              Logger().e("SAVED COUNTRY JSON: "+countryJson);
                              if (isBookmarked) {
                                // Unbookmark logic
                                bookmarkedCountriesJson.remove(countryJson);
                              } else {
                                // Bookmark logic
                                bookmarkedCountriesJson.add(countryJson);
                              }
                            });
                            saveBookmarks();  // Call function to save bookmarks locally
                          },
                          child: Image.asset(
                            width: 20.0,
                            height: 20.0,
                            isBookmarked
                                ? 'assets/images/bookmark_filled.png' // A filled bookmark image
                                : 'assets/images/bookmark.png',  // Empty bookmark image
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
