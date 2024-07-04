import 'package:flutter/material.dart';
import 'mainpage.dart';
import 'searchpage.dart';
import 'statspage.dart';
import 'profilepage.dart';
import 'additempage.dart';
import 'add_manual_entry_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For JSON encoding/decoding

class HomePage extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  final List<Map<String, dynamic>> items;

  HomePage({required this.items,required this.onThemeChanged});
  // HomePage({required this.onThemeChanged});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late List<Widget> _pages;
  String _appBarTitle = 'Home';
  late List<Map<String, dynamic>> _items;
  // List<Map<String, dynamic>> _items = []; // 保存添加的条目

  @override
  void initState() {
    super.initState();
    _items = widget.items; // 初始化 _items
    _pages = <Widget>[
      MainPage(items: _items,),
      SearchPage(),
      StatsPage(),
      ProfilePage(onThemeChanged: widget.onThemeChanged),
    ];
  }
  void _addItem(Map<String, dynamic> newItem) {
    setState(() {
      _items.add(newItem);
    });
    _saveItems();
  }

  void _saveItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String itemsString = json.encode(_items);
    await prefs.setString('items', itemsString);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          _appBarTitle = 'Home';
          break;
        case 1:
          _appBarTitle = 'Search';
          break;
        case 2:
          _appBarTitle = 'Stats';
          break;
        case 3:
          _appBarTitle = 'Profile';
          break;
      }
    });
  }

  Widget _buildIconButton(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 50),
        SizedBox(height: 5),
        Text(label),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle),
        centerTitle: true,
        actions: _selectedIndex == 0
            ? <Widget>[
                IconButton(
                  icon: Icon(Icons.add),
                  iconSize: 36.0,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.33, // 占据屏幕的三分之一
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                '请选择导入方式',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 20),
                              ListTile(
                                leading: Icon(Icons.input),
                                title: Text('手动录入'),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AddManualEntryPage(onAddItem: _addItem)),
                                  );
                                },
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildIconButton(Icons.link, '链接导入'),
                                  _buildIconButton(Icons.qr_code, '条码扫描'),
                                  _buildIconButton(Icons.medical_services, '药品扫描'),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ]
            : null,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black, // 设置未被选中时的颜色为黑色
        onTap: _onItemTapped,
      ),
    );
  }
}
