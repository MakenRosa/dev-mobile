import 'package:http/http.dart' as http; 

class GetApi {
  static Future<String> getApi(String url) async {
    var response = await http.get(Uri.parse(url));
    return response.body;
  }

  static Future<String> getApiContact() async {
    var url =
        "https://raw.githubusercontent.com/wellingtoncosta/fake-contacts-api/master/db.json";
    return GetApi.getApi(url);
  }
}