import 'dart:convert'; // Import for jsonEncode
import 'package:admin/models/all_survey_model.dart';
import 'package:http/http.dart' as http;

class AllSurveyRemoteService {
  final String baseUrl = 'http://localhost:3106/api';

  Future<List<AllSurvey>?> getAllSurvey() async {
    var client = http.Client();
    var uri = Uri.parse('$baseUrl/surveyQuestions');
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

  Future<bool> updateSurvey(
      String id, Map<String, dynamic> updatedSurvey) async {
    var client = http.Client();
    var uri = Uri.parse('http://localhost:3106/api/survey/$id');

    try {
      var response = await client.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updatedSurvey),
      );

      if (response.statusCode == 200) {
        print('Survey updated successfully.');
        return true;
      } else {
        print('Failed to update survey. Status code: ${response.statusCode}');
        print('Error response: ${response.body}');
      }
    } catch (e) {
      print('Error updating survey: $e');
    } finally {
      client.close();
    }
    return false;
  }

  Future<bool> updateQuestion(
      String id, Map<String, dynamic> updatedQuestion) async {
    var client = http.Client();
    var uri = Uri.parse('http://localhost:3106/api/question/$id');

    try {
      var response = await client.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updatedQuestion),
      );

      if (response.statusCode == 200) {
        print('Question updated successfully.');
        return true;
      } else {
        print('Failed to update question. Status code: ${response.statusCode}');
        print('Error response: ${response.body}');
      }
    } catch (e) {
      print('Error updating question: $e');
    } finally {
      client.close();
    }
    return false;
  }
}
