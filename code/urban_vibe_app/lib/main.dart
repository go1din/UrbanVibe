import 'package:flutter/material.dart';
import 'preferences_page.dart';
import 'search_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UrbanVibe App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  Map<String, String> selectedOptions = {};

  void _onOptionSelected(String category, String option) {
    setState(() {
      selectedOptions[category] = option;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 0
          ? PreferencesPage(
              selectedOptions: selectedOptions,
              onOptionSelected: _onOptionSelected,
            )
          : SearchPage(selectedOptions: selectedOptions),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Personal Preferences',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Recommendations',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
