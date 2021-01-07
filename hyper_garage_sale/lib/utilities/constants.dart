import 'package:flutter/material.dart';

/** post_screen - TextField Input Decoration **/
const kTextFieldInputDecoration = InputDecoration(
  filled: true,
  hintText: 'Enter title of the item',
  hintStyle: TextStyle(
    color: Colors.grey,
  ),
);

class Constants {
  static const String Subscribe = 'Subscribe';
  static const String Settings = 'Setting';
  static const String SignOut = 'Sing out';

  static const List<String> choices = <String>[Subscribe, Settings, SignOut];
}
