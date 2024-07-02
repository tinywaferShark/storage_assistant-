import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;

  HomePage({required this.onThemeChanged});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late List<Widget> _pages;
  String _appBarTitle = 'Home'; // 添加这个变量

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

class MainPage extends StatelessWidget {
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
        itemCount: 12, // For demonstration, we'll use 12 items.
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image, size: 50), // Placeholder for image
                SizedBox(height: 10),
                Text('Item $index'), // Placeholder for title
              ],
            ),
          );
        },
      ),
    );
  }
}

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Search Page'));
  }
}

class StatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Stats Page'));
  }
}

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
