import 'package:flutter/material.dart';
import 'home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For JSON encoding/decoding

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? itemsString = prefs.getString('items');
  List<Map<String, dynamic>> items = itemsString != null
      ? List<Map<String, dynamic>>.from(json.decode(itemsString))
      : [];

  runApp(MyApp(items: items));
}
class MyApp extends StatefulWidget {
  @override
  final List<Map<String, dynamic>> items;
  MyApp({required this.items});

  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _updateTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '收纳助理', // 修改应用的标题为中文
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: _themeMode,
      home: HomePage(onThemeChanged: _updateTheme, items: widget.items),
    );
  }
}
