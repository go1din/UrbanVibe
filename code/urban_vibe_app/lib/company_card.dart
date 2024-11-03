import 'package:flutter/material.dart';

class CompanyCard extends StatefulWidget {
  final String category;
  final List<Map<String, dynamic>> options;
  final String? selectedOption;
  final Function(String, String) onOptionSelected;

  CompanyCard({
    required this.category,
    required this.options,
    this.selectedOption,
    required this.onOptionSelected,
  });

  @override
  CompanyCardState createState() => CompanyCardState();
}

class CompanyCardState extends State<CompanyCard> {
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.selectedOption;
  }

  void _selectOption(String option) {
    setState(() {
      _selectedOption = option;
    });
    widget.onOptionSelected(widget.category, option);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              widget.category,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: widget.options
                .map((option) => _buildOptionCard(option))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(Map<String, dynamic> option) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _selectOption(option['label']);
        },
        child: Container(
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color:
                _selectedOption == option['label'] ? Colors.blue : Colors.grey,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Icon(
                option['icon'],
                color: Colors.white,
                size: 40,
              ),
              SizedBox(height: 5),
              Text(
                option['label'],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
