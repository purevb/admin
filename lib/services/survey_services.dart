import 'package:admin/models/survey_model.dart';
import 'package:http/http.dart' as http;

class SurveyRemoteService {
  Future<List<Survey>?> getSurvey() async {
    var clients = http.Client();
    var uris = Uri.parse('http://localhost:3106/api/survey');
    try {
      var response = await clients.get(uris);
      if (response.statusCode == 200) {
        var json = response.body;
        return surveyFromJson(json);
      } else {
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Network error: $e');
    } finally {
      clients.close();
    }
    return null;
  }
}
