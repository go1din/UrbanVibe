import 'package:flutter/material.dart';
import 'event_detail_page.dart';

class SearchPageList extends StatelessWidget {
  final TextEditingController controller;
  final List<Map<String, String>> events;
  final bool isLoading;
  final VoidCallback onSearch;

  SearchPageList({
    required this.controller,
    required this.events,
    required this.isLoading,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Search for events...',
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: onSearch,
              ),
            ),
          ),
        ),
        Expanded(
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventDetailPage(event: event),
                          ),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            event['imageUrl'] != null &&
                                    event['imageUrl']!.isNotEmpty
                                ? Image.network(
                                    event['imageUrl']!,
                                    width: MediaQuery.of(context).size.width,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 200,
                                    color: Colors.grey[300],
                                    child: Center(
                                      child: Text(
                                        event['description']!,
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                event['name']!,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(event['address']!),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(event['openingHours']!),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(event['description']!),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
