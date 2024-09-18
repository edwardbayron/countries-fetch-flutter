import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'CountryDatabaseModel.dart';
import 'models/CountryDataModel.dart';

void main() =>
    runApp(
        CountryDetailsScreen(
            model: CountryModel(
                capital: 'Tallinn',
                pngFlag: 'https://flagcdn.com/w320/ee.png',
                countryName: 'Estonia',
                carSigns: ['EST'],
                carDrivingSide: 'right',
                languages: null,
                nativeNames: null
            ),
          dbModel: CountryDatabaseModel(
              capital: 'Tallinn',
              pngFlag: 'https://flagcdn.com/w320/ee.png',
              countryName: 'Estonia',
              carSigns: 'EST',
              carDrivingSide: 'right',
              languages: '',
              nativeNames: ''),
        ));

class CountryDetailsScreen extends StatelessWidget {
  final CountryModel model;
  final CountryDatabaseModel dbModel;

  CountryDetailsScreen({super.key, required this.model, required this.dbModel});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Country details')),
        body: Center(
          child: DialogExample(model: model, dbModel: dbModel),
        ),
      ),
    );
  }
}

class DialogExample extends StatefulWidget {
  final CountryModel model;
  final CountryDatabaseModel dbModel;

  DialogExample({super.key, required this.model, required this.dbModel});


  @override
  State<DialogExample> createState() => _DialogExampleState();
}

class _DialogExampleState extends State<DialogExample> {
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    loadBookmarkStatus();
  }

  void loadBookmarkStatus() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedBookmarks = prefs.getStringList('bookmarkedCountries') ??
        [];

    setState(() {
      isBookmarked = savedBookmarks.contains(jsonEncode(widget.model?.toJson()));
    });
  }

  void toggleBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedBookmarks = prefs.getStringList('bookmarkedCountries') ??
        [];

    String countryJson = jsonEncode(widget.model?.toJson());

    setState(() {
      if (isBookmarked) {
        savedBookmarks.remove(countryJson);
      } else {
        savedBookmarks.add(countryJson);
      }

      isBookmarked = !isBookmarked;
    });

    await prefs.setStringList('bookmarkedCountries', savedBookmarks);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        children: [
          Column(
            children: [
              if(widget.model.countryName?.isNotEmpty == true)
                Align(
                    alignment: Alignment.centerLeft,
                    child:
                       Text("Country name: ${widget.model.countryName}"))
              else
                  Align(
                  alignment: Alignment.centerLeft,
                  child:
                  Text("Country name: ${widget.dbModel.countryName}"),
              ),

              SizedBox(width: 10.0),
              if(widget.model.capital?.isNotEmpty == true)
                Align(
                    alignment: Alignment.centerLeft,
                    child:
                    Text("Capital: ${widget.model.capital}"))
              else
                Align(
                  alignment: Alignment.centerLeft,
                  child:
                  Text("Capital: ${widget.dbModel.capital}"),
                ),

              SizedBox(width: 10.0),
              if(widget.model.pngFlag?.isNotEmpty == true)
                Align(
                  alignment: Alignment.centerLeft,
                  child:
                  Image.network(
                    widget.model.pngFlag ?? 'N/A',
                    width: 20.0,
                    height: 20.0,
                  ),
                )
              else
                Align(
                  alignment: Alignment.centerLeft,
                  child:
                  Image.network(
                    widget.dbModel.pngFlag ?? 'N/A',
                    width: 20.0,
                    height: 20.0,
                  ),
                ),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            children: [
              Text('Population: [to be added]'),
            ],
          ),
          const SizedBox(height: 10.0),
          if(widget.dbModel.carSigns.toString().isNotEmpty)
            Text('Car signs: ${widget.dbModel.carSigns.toString()}')
          else
            for(var item in widget.model.carSigns ?? [])
              Text('Car signs: ' + item.toString()),
          Row(
            children: [
              if(widget.model.carDrivingSide?.isNotEmpty == true)
                Text('Car driving side: ' + widget.model.carDrivingSide.toString())
              else
                Text('Car driving side: ' + widget.dbModel.carDrivingSide.toString()),
            ],
          ),
          Column(
            children: [
              if(widget.model.languages?.isNotEmpty == true)
                for (var entry in widget.model.languages!.entries)
                  if (widget.model.nativeNames!.containsKey(entry.key))
                    Align(
                      alignment: Alignment.centerLeft,
                      child:
                      Text('${entry.value}: ' + widget.model.nativeNames![entry
                          .key]['common'])
                      ,
                    )


            ],
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var entry in jsonDecode(widget.dbModel.languages).entries)
                Text('${entry.value}: ${jsonDecode(widget.dbModel.nativeNames)[entry.key]['common']}'),
            ],
          )


        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: isBookmarked ? Colors.blue : Colors.grey,
          ),
          onPressed: toggleBookmark,
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}