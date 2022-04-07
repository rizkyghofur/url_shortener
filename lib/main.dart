import 'package:flutter/material.dart';
import 'package:url_shortener/pages/URLShortenerPage.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'URL Shortener',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: URLShortenerPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
