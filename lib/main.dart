import 'package:flutter/material.dart';
import 'journal_app.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Journal App',
      home: JournalApp(),
    );
  }
}