import 'package:flutter/material.dart';
import 'dart:io';

class MainPage extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  MainPage({required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.0,
        ),
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                items[index]['image'] != null
                    ? Image.file(File(items[index]['image']), height: 50)
                    : Icon(Icons.image, size: 50), // Placeholder for image
                SizedBox(height: 10),
                Text(items[index]['name']), // Item title
                SizedBox(height: 5),
                Wrap(
                  children: items[index]['tags']
                      .map<Widget>((tag) => Chip(label: Text(tag)))
                      .toList(),
                ), // Item tags
              ],
            ),
          );
        },
      ),
    );
  }
}