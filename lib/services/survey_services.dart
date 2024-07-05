import 'package:admin/models/survey_model.dart';
import 'package:http/http.dart' as http;

class SurveyRemoteService {
  Future<List<Survey>?> getSurvey() async {
    var client = http.Client();
    var uri = Uri.parse('http://10.0.2.2:3106/api/survey');
    try {
      var response = await client.get(uri);
      if (response.statusCode == 200) {
        var json = response.body;
        return postFromJson(json);
      } else {
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Network error: $e');
    } finally {
      client.close();
    }
    return null;
  }
}
