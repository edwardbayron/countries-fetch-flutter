import 'package:flutter/material.dart';

import 'ListItem.dart';

class CountryListItem implements ListItem{
  final String countryName;
  final int flag; // switch after to Image data type
  final String capitalName;
  final int population;
  final String carSign;
  final String carDrivingSide;

  CountryListItem(this.countryName, this.flag, this.capitalName, this.population, this.carSign, this.carDrivingSide);


  @override
  Widget buildCapital(BuildContext context) {
    return Text(
      capitalName,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  @override
  Widget buildCarDrivingSide(BuildContext context) {
    return Text(
      carDrivingSide,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  @override
  Widget buildCarSign(BuildContext context) {
    return Text(
      carSign,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  @override
  Widget buildCountryName(BuildContext context) {
    return Text(
      countryName,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  @override
  Widget buildFlag(BuildContext context) {
    return Text(
      flag.toString(),
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  @override
  Widget buildPopulation(BuildContext context) {
    return Text(
      population.toString(),
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

}