import 'package:flutter/material.dart';

class CountryItemWidget extends StatefulWidget {
  const CountryItemWidget({super.key, required this.capitalName, required this.image});

  final int image;
  final String capitalName;


  @override
  State<CountryItemWidget> createState() => _CountryItemWidgetState();
}

class _CountryItemWidgetState extends State<CountryItemWidget> {

  @override
  Widget build(BuildContext context) {
    return Card(child:
        Row(
          children: [
            Text(widget.image.toString()),
            SizedBox(width: 20.0,),
            Text(widget.capitalName),

          ],
        )

    );
  }

}