import 'package:flutter/material.dart';

import 'models/CountryDataModel.dart';

/// Flutter code sample for [AlertDialog].

void main() => runApp(BookmarkedCountriesScreen(model: CountryModel(capital: '', pngFlag: '')));

class BookmarkedCountriesScreen extends StatelessWidget {
  final CountryModel model;
  const BookmarkedCountriesScreen({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('AlertDialog Sample')),
        body: Center(
          child: DialogExample(model: model),
        ),
      ),
    );
  }
}

class DialogExample extends StatelessWidget {
  final CountryModel model;
  const DialogExample({super.key, required this.model});


  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Capital: ${model.capital}'),
          content: const Text('AlertDialog description'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
      child: const Text('Show Dialog'),
    );
  }
}