import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'models/CountryDataModel.dart';

void main() => runApp(
    CountryDetailsScreen(model: CountryModel(capital: 'Tallinn', pngFlag: 'https://flagcdn.com/w320/ee.png')));

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
    List<String> savedBookmarks = prefs.getStringList('bookmarkedCountries') ?? [];

    setState(() {
      isBookmarked = savedBookmarks.contains(jsonEncode(widget.model.toJson()));
    });
  }

  void toggleBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedBookmarks = prefs.getStringList('bookmarkedCountries') ?? [];

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
      title: const Text('Country details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text('Country name:'),
              const SizedBox(width: 10.0),
              Text(widget.model.capital ?? 'Unknown Capital'),
              const SizedBox(width: 10.0),
              Image.network(
                widget.model.pngFlag ?? 'N/A',
                width: 20.0,
                height: 20.0,
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            children: [
              const Text('Population:'),
              // Placeholder for population data, modify based on your data
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            children: [
              const Text('Car sign:'),
              const SizedBox(width: 10.0),
              const Text('Card driving side'),
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