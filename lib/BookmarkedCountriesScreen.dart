import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vool_test_project/CountryDetailsScreen.dart';
import 'package:vool_test_project/models/CountryDataModel.dart';
import 'CountryDatabaseModel.dart';
import 'DB.dart';
import 'package:http/http.dart' as http;

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
  bool hasChanges = false;

  @override
  void initState() {
    super.initState();
    futureBookmarkedCountries = database.readAll();
  }

  List<CountryModel> getBookmarkedCountries() {
    return bookmarkedCountriesList;
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

  void showCountryDetails(CountryDatabaseModel country) async {
    final  result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CountryDetailsScreen(
            model: CountryModel(
              capital: country.capital,
              pngFlag: country.pngFlag,
              countryName: country.countryName,
              carSigns: country.carSigns?.split(','),
              carDrivingSide: country.carDrivingSide,
              languages: jsonDecode(country.languages),
              nativeNames: jsonDecode(country.nativeNames),
            ),
            dbModel: country),
      ),
    );

    if (result != null && result['bookmarkChanged'] == true) {
      setState(() {
        hasChanges = true;
        futureBookmarkedCountries = database.readAll();
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop({'bookmarkChanged': true});
          fetchCountriesData();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop({'bookmarkChanged': hasChanges});
        return false;
      },
        child:
    Scaffold(
      appBar: AppBar(
        title: Text("Bookmarks Screen"),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(onPressed: () => {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () => {
          }, icon: const Icon(Icons.bookmark)),
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
                      padding: const EdgeInsets.all(10.0),
                      margin: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54)),
                      height: 60.0,
                      child: Row(children: [
                        Image.network(
                            width: 20.0,
                            height: 20.0,
                            country.pngFlag ?? 'N/A'),
                        const SizedBox(width: 10.0),
                        Text(country.capital ?? 'Unknown Capital'),
                        const Expanded(child: SizedBox()),

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
    )
    );
  }
}

