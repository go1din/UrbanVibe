import 'dart:convert';
import 'package:http/http.dart' as http;

class UnsplashApi {
  final String apiKey = '57zujSozpPHHwx50s6O2k6ZNt_Jd1n5uEWc2dcrjY6A';
  final String endpoint = 'https://api.unsplash.com/search/photos';

  Future<String?> fetchImageUrl(String query) async {
    final response = await http.get(
      Uri.parse('$endpoint?query=$query&client_id=$apiKey'),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final results = responseBody['results'];
      if (results != null && results.isNotEmpty) {
        return results[0]['urls']['small'];
      } else {
        return null;
      }
    } else {
      print('Failed to load image: ${response.statusCode}');
      return null;
    }
  }
}
