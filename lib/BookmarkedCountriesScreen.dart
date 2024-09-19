import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vool_test_project/CountryDetailsScreen.dart';
import 'package:vool_test_project/models/CountryDataModel.dart';

import 'CountryDatabaseModel.dart';
import 'DB.dart';

List<CountryModel> bookmarkedCountriesList = [];

class BookmarkedCountriesScreen extends StatefulWidget {
  const BookmarkedCountriesScreen({super.key});

  @override
  State<BookmarkedCountriesScreen> createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<BookmarkedCountriesScreen> {

  DB database = DB.instance;
  Set<String> bookmarkedCountriesJson = Set();
  late Future<List<CountryDatabaseModel>> futureBookmarkedCountries;

  @override
  void initState() {
    super.initState();
    loadBookmarksSync();
    futureBookmarkedCountries = DB.instance.readAll();
  }

  List<CountryModel> getBookmarkedCountries() {
    return bookmarkedCountriesList; // Accessing the globally stored data synchronously
  }

  void showCountryDetails(CountryDatabaseModel country) async {
    final bool? bookmarkChanged = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return CountryDetailsScreen(
            model: CountryModel(
              capital: country.capital,
              pngFlag: country.pngFlag,
              countryName: country.countryName,
              carSigns: country.carSigns?.split(','),
              carDrivingSide: country.carDrivingSide,
              languages: jsonDecode(country.languages),
              nativeNames: jsonDecode(country.nativeNames),
            ),
            dbModel: country);
      },
    );

    if (bookmarkChanged == true) {
      setState(() {
        futureBookmarkedCountries = database.readAll();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bookmarks Screen"),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(onPressed: () => {}, icon: Icon(Icons.search)),
          IconButton(onPressed: () => {
          }, icon: Icon(Icons.bookmark)),
        ],
      ),
      body: Center(
        child: FutureBuilder<List<CountryDatabaseModel>>(
          future: database.readAll(),
          builder: (context, snapshot) {

            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  elevation: 12.0,
                  textStyle: const TextStyle(color: Colors.yellow)),
              child: const Text('Bookmarked Countries'),
            );
            if (snapshot.hasData) {
              List<CountryDatabaseModel> countries = snapshot.data!;

              return ListView.builder(
                itemCount: countries.length,
                itemBuilder: (context, index) {
                  CountryDatabaseModel country = countries[index];
                  bool isBookmarked = countries.any(
                          (bookmarked) =>
                      bookmarked.capital == country.capital);
                  return GestureDetector(
                    onTap: () => showCountryDetails(country),
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



void loadBookmarksSync() {
  SharedPreferences.getInstance().then((prefs) {
    List<String>? savedBookmarks = prefs.getStringList('bookmarkedCountries');
    if (savedBookmarks != null) {
      bookmarkedCountriesList = savedBookmarks.map((countryJson) {
        Map<String, dynamic> data = jsonDecode(countryJson);

        if (data['languages'] is String) {
          data['languages'] = jsonDecode(data['languages']);
        }

        if (data['pngFlag'] is String) {
          data['pngFlag'] = "https://flagcdn.com/w320/gs.png";
        }

        if (data['commonNames'] is String) {
          data['name'] = {'nativeName': jsonDecode(data['commonNames'])};
          data.remove('commonNames');
        }

        return CountryModel.fromJsonV2(data);
      }).toList();

    }
  });
}