import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
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
  late Future<List<CountryModel>> bookmarkedCountriesList;
  Set<String> bookmarkedCountriesJson = Set();

  @override
  void initState() {
    loadBookmarks();
  }

  // Future<List<CountryModel>> getBookmarkedCountries() async {
  //   List<CountryModel> countriesList = bookmarkedCountriesJson.map((countryJson){
  //     return jsonDecode(countryJson);
  //   }).toList();
  //   return Future.value(countriesList);
  // }
  Future<List<CountryModel>> getBookmarkedCountries(String json) async {
    List<dynamic> data = jsonDecode(json);
    return data.map((json) => CountryModel.fromJson(json)).toList();
  }


  Future<void> loadBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedBookmarks = prefs.getStringList('bookmarkedCountries');
    Logger().e("YOLO SAVED BOOKMARKS: " + savedBookmarks.toString());


    if (savedBookmarks != null) {
      bookmarkedCountriesJson = savedBookmarks.toSet();
      bookmarkedCountriesList = getBookmarkedCountries(savedBookmarks.toString());
    }

    // After loading bookmarks, initialize the future list
    //setState(() {

    //});
  }



  @override
  Widget build(BuildContext context) {
   // Logger().e("Test length: " + bookmarkedCountriesList.length.toString());
   // Logger().e("Test length: " + bookmarkedCountriesList.length.toString());


    return Scaffold(
        appBar: AppBar(
          title: Text("Bookmarks Screen"),
        ),
        body: Center(
          child: FutureBuilder<List<CountryModel>>(
          future: bookmarkedCountriesList,
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              List<CountryModel> countries = snapshot.data!;
              return ListView.builder(

                itemCount: countries.length,
                itemBuilder: (context, index) {
                  // Logger().e("YOLO: 2 capital: " +
                  //     bookmarkedCountriesList.first.capital.toString());
                  // Logger().e("YOLO: 2 png: " +
                  //     bookmarkedCountriesList.first.pngFlag.toString());
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
                },


              );
            }
            else if(snapshot.hasError){
              Text("Error snapshot has no data");
            }

            return const CircularProgressIndicator();
          }

          )));
  }
}
