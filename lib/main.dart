import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '收纳助理', // 修改应用的标题为中文
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(
        onThemeChanged: (ThemeMode themeMode) {
          // 这里可以根据主题变更执行操作
        },
      ),
    );
  }
}
