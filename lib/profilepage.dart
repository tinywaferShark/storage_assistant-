import 'package:flutter/material.dart';

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
