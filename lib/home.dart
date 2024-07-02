import 'package:flutter/material.dart';
import 'mainpage.dart';
import 'searchpage.dart';
import 'statspage.dart';
import 'profilepage.dart';
import 'additempage.dart';

class HomePage extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;

  HomePage({required this.onThemeChanged});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late List<Widget> _pages;
  String _appBarTitle = 'Home';

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      MainPage(),
      SearchPage(),
      StatsPage(),
      ProfilePage(onThemeChanged: widget.onThemeChanged),
    ];
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddItemPage()),
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
