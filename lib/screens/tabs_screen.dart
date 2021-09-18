import 'package:flutter/material.dart';
import 'package:smart_pos/screens/dashboard_screen.dart';
import 'package:smart_pos/screens/inventory_screen.dart';
import 'package:smart_pos/screens/shops_screen.dart';
import 'package:smart_pos/widgets/main_drawer.dart';

class TabScreen extends StatefulWidget {
  TabScreen();
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  List<Map<String, Object>> _screens = [];
  int _selectedScreenIndex = 0;

  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  void initState() {
    _screens = [
      {"page": DashboardScreen(), "title": "Dashboard"},
      {"page": InventoryScreen(), "title": "Inventory"},
      {"page": ShopsScreen(), "title": "Shops"}
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Smart POS"),
      ),
      drawer: MainDrawer(),
      body: _screens[_selectedScreenIndex]["page"] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectScreen,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white54,
        selectedItemColor: Colors.white,
        currentIndex: _selectedScreenIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2), label: "Inventory"),
          BottomNavigationBarItem(icon: Icon(Icons.shop_2), label: "Shops"),
        ],
      ),
    );
  }
}
