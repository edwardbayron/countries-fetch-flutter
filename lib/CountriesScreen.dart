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
  late Future<List<CountryDatabaseModel>> futureBookmarkedCountries;

  @override
  void initState() {
    super.initState();

    setState(() {
      fetchCountriesData();
      futureCountries = fetchCountriesData();
      futureBookmarkedCountries = database.readAll();

    });

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

  void showCountryDetails(CountryModel country) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CountryDetailsScreen(
            model: country,
            dbModel: CountryDatabaseModel(
                capital: '',
                pngFlag: '',
                countryName: '',
                carSigns: '',
                carDrivingSide: '',
                languages: '',
                nativeNames: '')),
      ),
    );


    if (result != null && result['bookmarkChanged'] == true) {
      setState(() {
        futureBookmarkedCountries = database.readAll();
        fetchCountriesData();
      });
    }
  }

  void openBookmarks() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const BookmarkedCountriesScreen()),
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
            IconButton(
                onPressed: () => {openBookmarks()}, icon: Icon(Icons.bookmark)),
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
                    return FutureBuilder<List<CountryDatabaseModel>>(
                      future: futureBookmarkedCountries,
                      builder: (context, bookmarkSnapshot) {
                        if (bookmarkSnapshot.hasData) {
                          List<CountryDatabaseModel> bookmarkedCountries =
                              bookmarkSnapshot.data!;
                          return ListView.builder(
                            itemCount: countries.length,
                            itemBuilder: (context, index) {
                              CountryModel country = countries[index];
                              bool isBookmarked = bookmarkedCountries.any(
                                  (bookmarked) =>
                                      bookmarked.capital == country.capital);
                              return GestureDetector(
                                onTap: () => showCountryDetails(country),
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  margin: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.black54)),
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
                                          if (isBookmarked) {
                                            database.delete(country.capital!);
                                          } else {
                                            database.create(country);
                                          }
                                        });
                                        futureBookmarkedCountries = database.readAll();
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
                    );
                  }
                  return const CircularProgressIndicator();
                })));
  }
}
