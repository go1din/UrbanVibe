import 'package:flutter/material.dart';
import 'category_card.dart';
import 'company_card.dart';

import 'wether_widget.dart';

class PreferencesPage extends StatefulWidget {
  final Map<String, String> selectedOptions;
  final Function(String, String) onOptionSelected;

  PreferencesPage(
      {required this.selectedOptions, required this.onOptionSelected});

  @override
  PreferencesPageState createState() => PreferencesPageState();
}

class PreferencesPageState extends State<PreferencesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi, Max!'),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Here you can set your personal preferences!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          WeatherWidget(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'We tailor the best activities just for you considering your location, current weather conditions, daytime and much more. Based on your preferences, we have the best results for you!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Contact us: www.urbanvibe.contact',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Center(
            child: Image.asset(
              'assets/logo.png',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
          CompanyCard(
            category: 'Company',
            options: [
              {'label': 'Alone', 'icon': Icons.person},
              {'label': 'Friends', 'icon': Icons.group},
              {'label': 'Family', 'icon': Icons.family_restroom},
            ],
            selectedOption: widget.selectedOptions['Company'],
            onOptionSelected: widget.onOptionSelected,
          ),
          CategoryCard(
            category: 'Food',
            options: ['Italian', 'Asian', 'German'],
            selectedOption: widget.selectedOptions['Food'],
            onOptionSelected: widget.onOptionSelected,
          ),
          CategoryCard(
            category: 'Sport',
            options: ['Football', 'Basketball', 'Tennis'],
            selectedOption: widget.selectedOptions['Sport'],
            onOptionSelected: widget.onOptionSelected,
          ),
          CategoryCard(
            category: 'Music',
            options: ['Rock', 'Jazz', 'Classical'],
            selectedOption: widget.selectedOptions['Music'],
            onOptionSelected: widget.onOptionSelected,
          ),
          CategoryCard(
            category: 'Travel',
            options: ['Beach', 'Mountains', 'City'],
            selectedOption: widget.selectedOptions['Travel'],
            onOptionSelected: widget.onOptionSelected,
          ),
          CategoryCard(
            category: 'Wellness',
            options: ['Yoga', 'Spa', 'Meditation'],
            selectedOption: widget.selectedOptions['Wellness'],
            onOptionSelected: widget.onOptionSelected,
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) =>
      //             SearchPage(selectedOptions: widget.selectedOptions),
      //       ),
      //     );
      //   },
      //   child: Icon(Icons.search),
      // ),
    );
  }
}
