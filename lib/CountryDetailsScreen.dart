import 'package:flutter/material.dart';

import 'models/CountryDataModel.dart';

/// Flutter code sample for [AlertDialog].

void main() => runApp(
    CountryDetailsScreen(model: CountryModel(capital: '', pngFlag: '')));

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

class DialogExample extends StatelessWidget {
  final CountryModel model;

  const DialogExample({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    // return TextButton(
    //   onPressed: () => showDialog<String>(
    //     context: context,
    //     builder: (BuildContext context) => AlertDialog(
    //       title: Text('Capital: ${model.capital}'),
    //       content: const Text('AlertDialog description'),
    //       actions: <Widget>[
    //         TextButton(
    //           onPressed: () => Navigator.pop(context, 'Cancel'),
    //           child: const Text('Cancel'),
    //         ),
    //         TextButton(
    //           onPressed: () => Navigator.pop(context, 'OK'),
    //           child: const Text('OK'),
    //         ),
    //       ],
    //     ),
    //   ),
    //   child: const Text('Show Dialog'),
    // );

    return Material(
        child: Container(
          width: 400,
            padding: const EdgeInsets.fromLTRB(40.0, 70.0, 40.0, 50.0),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [

                Row(
                  children: [
                    Text('Country name'),
                    SizedBox(width: 10.0),
                    Text('${model.capital}'),
                    SizedBox(width: 10.0),
                    Image.network(
                        width: 20.0,
                        height: 20.0,
                        model.pngFlag ?? 'N/A'),

                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    Text('Population'),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    Text('Car sign'),
                    SizedBox(width: 10.0),
                    Text('Card driving side')
                  ],
                ),
                SizedBox(height: 10.0),
                // ListView.builder(
                // itemCount: 2,
                // itemBuilder: (context, index) {
                //   Row(children: [
                //     Text('Finnish'),
                //     SizedBox(width: 10.0),
                //     Text('Suomi')
                //   ],);
                // }),





              ],
            )));
  }
}
