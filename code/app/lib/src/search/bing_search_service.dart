import 'dart:convert';
import 'package:http/http.dart' as http;
import 'image_search_service.dart';

class BingSearchService {
  final String apiKey = 'c054ff57037c4005ace3eaf38351e4eb';
  final String endpoint = 'https://citypulse.openai.azure.com/';

  Future<List<Map<String, String>>> search(String query) async {
    final String prompt =
        'Act as leisure coach, give short informations on possible events in the format event_name#event_address#event_openinghours#event_description for location: $query. Event_description shall not exceed the size of 100 characters. Give me 10 results.';

    final response = await http.post(
      Uri.parse(
          '$endpoint/openai/deployments/gpt-35-turbo/chat/completions?api-version=2024-02-15-preview'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'api-key': apiKey,
      },
      body: json.encode({
        'messages': [
          {
            'role': 'system',
            'content': prompt,
          }
        ],
        'max_tokens': 4000,
        'temperature': 0.7,
        'frequency_penalty': 0,
        'presence_penalty': 0,
        'top_p': 0.95,
        'stop': null,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(utf8.decode(response.bodyBytes));
      final choices = responseBody['choices'];
      if (choices != null && choices.isNotEmpty) {
        final String content = choices[0]['message']['content'];
        final events = await Future.wait(content
            .split('\n')
            .where((event) => event.isNotEmpty)
            .map((event) async {
              final parts = event.split('#');
              final imageUrl = await fetchImageUrl(parts[0].trim());
              return {
                'name': parts[0].trim(),
                'address': parts[1].trim(),
                'openingHours': parts[2].trim(),
                'description': parts[3].trim(),
                'imageUrl': imageUrl ?? '',
              };
            })
            .toList()
            .cast<
                Future<
                    Map<String,
                        String>>>()); // Ensure the list is correctly typed
        //print(events);
        return events;
      } else {
        throw Exception('No choices found in the response');
      }
    } else {
      //print('Failed to load search results: ${response.statusCode}');
      //print('Response body: ${response.body}');
      throw Exception('Failed to load search results');
    }
  }
}
