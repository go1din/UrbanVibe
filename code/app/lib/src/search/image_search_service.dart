import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

Future<String?> fetchImageUrl(String searchTerm) async {
  final url = 'https://pixabay.com/images/search/$searchTerm/';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var document = parser.parse(response.body);
    var imageElement = document.querySelector('img[srcset]');
    if (imageElement != null) {
      var srcset = imageElement.attributes['srcset'];
      if (srcset != null) {
        var urls = srcset.split(', ');
        if (urls.isNotEmpty) {
          // Fetch the smallest image URL
          var smallestImageUrl = urls.first.split(' ')[0];
          return smallestImageUrl;
        }
      }
    }
  }
  return null;
}
