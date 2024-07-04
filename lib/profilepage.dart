import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For JSON encoding/decoding
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class ProfilePage extends StatelessWidget {
  final Function(ThemeMode) onThemeChanged;

  ProfilePage({required this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: List.generate(10, (index) {
          if (index == 0) {
            return ListTile(
              title: Text('主题'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                _showThemeDialog(context);
              },
            );
          }
          else if (index == 1) {
            return ListTile(
              title: Text('备份与恢复'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BackupRestorePage()),
                );
              },
            );
          }
          return ListTile(
            title: Text('设置项 $index'),
            trailing: Icon(Icons.arrow_forward_ios),
          );
        }),
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('选择主题'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('跟随系统'),
                onTap: () {
                  onThemeChanged(ThemeMode.system);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('白天'),
                onTap: () {
                  onThemeChanged(ThemeMode.light);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('黑暗'),
                onTap: () {
                  onThemeChanged(ThemeMode.dark);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class BackupRestorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('备份与恢复'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => _exportItems(context),
              child: Text('备份'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _importItems(context),
              child: Text('恢复'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportItems(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? itemsString = prefs.getString('items');
    if (itemsString == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('没有找到可备份的数据')),
      );
      return;
    }

    String? outputPath = await FilePicker.platform.getDirectoryPath();
    if (outputPath != null) {
      final String formattedTime = DateFormat('yyyy_MM_dd_HH_mm_ss').format(DateTime.now());
      final String fileName = 'storage_store_$formattedTime.json';
      final File file = File('$outputPath/$fileName');
      await file.writeAsString(itemsString);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('数据已备份至 $outputPath/$fileName')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('未选择存储位置')),
      );
    }
  }
  Future<void> _importItems(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null) {
      final File file = File(result.files.single.path!);
      final String itemsString = await file.readAsString();
      final List<Map<String, dynamic>> importedItems =
      List<Map<String, dynamic>>.from(json.decode(itemsString));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('items', json.encode(importedItems));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('数据已从 ${file.path} 恢复')),
      );
    }
  }
}