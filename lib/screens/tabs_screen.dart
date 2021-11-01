import 'package:flutter/material.dart';
import 'package:smart_pos/screens/dashboard_screen.dart';
import 'package:smart_pos/screens/inventory_screen.dart';
import 'package:smart_pos/screens/shops_screen.dart';
import 'package:smart_pos/widgets/main_drawer.dart';

class TabScreen extends StatefulWidget {
  static const routeName = "/tabs";
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  List<Map<String, Object>> _screens = [];
  int _selectedScreenIndex = 0;

  @override
  @override
  void initState() {
    _screens = [
      {"page": DashboardScreen(), "title": "Dashboard"},
      {"page": InventoryScreen(), "title": "Inventory"},
      {"page": ShopsScreen(), "title": "Shops"}
    ];
    super.initState();
  }

  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart POS"),
      ),
      drawer: MainDrawer(),
      body: _screens[_selectedScreenIndex]["page"] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        key: Key('bottom'),
        onTap: _selectScreen,
        backgroundColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.white54,
        selectedItemColor: Colors.white,
        currentIndex: _selectedScreenIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
              icon: const Icon(
                Icons.dashboard,
                key: Key("dashboardIcon"),
              ),
              label: "Dashboard"),
          const BottomNavigationBarItem(
              icon: const Icon(
                Icons.inventory_2,
                key: Key("inventoryIcon"),
              ),
              label: "Inventory"),
          const BottomNavigationBarItem(
              icon: const Icon(
                Icons.shop_2,
                key: Key("shopsIcon"),
              ),
              label: "Shops"),
        ],
      ),
    );
  }
}
