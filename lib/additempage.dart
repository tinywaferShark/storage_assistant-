import 'package:flutter/material.dart';

class AddItemPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('添加存储信息'),
      ),
      body: Center(
        child: Text('在这里添加存储信息的表单'),
      ),
    );
  }
}