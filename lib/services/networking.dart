import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class NetworkHelper {
  String url;
  NetworkHelper(this.url);

  Future<dynamic> getJSON() async {
    // Await the http get response, then decode the json-formatted response.
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      String data = response.body;
      return convert.jsonDecode(data);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }
}
