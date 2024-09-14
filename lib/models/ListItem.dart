import 'package:flutter/material.dart';

abstract class ListItem {
  Widget buildCountryName(BuildContext context);

  Widget buildFlag(BuildContext context);

  Widget buildCapital(BuildContext context);

  Widget buildPopulation(BuildContext context);

  Widget buildCarSign(BuildContext context);

  Widget buildCarDrivingSide(BuildContext context);
}