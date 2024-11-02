import 'package:flutter/material.dart';
import 'bing_search_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final BingSearchService _bingSearchService = BingSearchService();
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _events = [];
  bool _isLoading = false;

  void _search() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final events = await _bingSearchService.search(_controller.text);
      setState(() {
        _events = events;
      });
      // Print image URLs for debugging
      // for (var event in events) {
      //   print('Image URL: ${event['imageUrl']}');
      // }
    } catch (e) {
      // print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UrbanVibe App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _search,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _events.length,
                      itemBuilder: (context, index) {
                        final event = _events[index];
                        return Card(
                          child: ListTile(
                            title: Text(event['name'] ?? ''),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Address: ${event['address']}'),
                                Text('Opening Hours: ${event['openingHours']}'),
                                Text('Description: ${event['description']}'),
                                event['imageUrl'] != null &&
                                        event['imageUrl']!.isNotEmpty
                                    ? Image.network(
                                        event['imageUrl']!,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Text(
                                              'Image cannot be fetched');
                                        },
                                      )
                                    : const Text('No image available'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
