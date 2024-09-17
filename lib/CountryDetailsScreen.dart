import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
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
            )));

class CountryDetailsScreen extends StatelessWidget {
  final CountryModel model;

  const CountryDetailsScreen({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Country details')),
        body: Center(
          child: DialogExample(model: model),
        ),
      ),
    );
  }
}

class DialogExample extends StatefulWidget {
  final CountryModel model;

  const DialogExample({super.key, required this.model});

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
      isBookmarked = savedBookmarks.contains(jsonEncode(widget.model.toJson()));
    });
  }

  void toggleBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedBookmarks = prefs.getStringList('bookmarkedCountries') ??
        [];

    String countryJson = jsonEncode(widget.model.toJson());

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
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(widget.model.countryName ?? 'Unknown Country'),
              ),

              SizedBox(width: 10.0),
              Align(
                alignment: Alignment.centerLeft,
                child:
                Text(widget.model.capital ?? 'Unknown Capital'),
              ),

              SizedBox(width: 10.0),
              Align(
                alignment: Alignment.centerLeft,
                child:
                Image.network(
                  widget.model.pngFlag ?? 'N/A',
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
          Row(
            children: [
              Text('Car signs: ' + widget.model.carSigns.toString()),
            ],
          ),
          Row(
            children: [
              Text('Card driving side: ' +
                  widget.model.carDrivingSide.toString()),
            ],
          ),
          // for (var entry in widget.model.languages!.entries)
          //   Text('Language (${entry.key}): ${entry.value}'),
          // Text("Common: "+widget.model.getNativeCommonNames(widget.model)),
          // for(var i in widget.model.getNativeCodes(widget.model))
          //   Text(i),

          Column(
            children: [
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