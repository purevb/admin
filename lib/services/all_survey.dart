import 'package:admin/models/all_survey_model.dart';
import 'package:http/http.dart' as http;

class AllSurveyRemoteService {
  Future<List<AllSurvey>?> getAllSurvey() async {
    var client = http.Client();
    var uri = Uri.parse('http://localhost:3106/api/surveyQuestions');
    try {
      var response = await client.get(uri);
      if (response.statusCode == 200) {
        var json = response.body;
        return allSurveyFromJson(json);
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
