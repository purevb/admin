import 'package:admin/models/question_model.dart';
import 'package:http/http.dart' as http;

class QuestionRemoteService {
  Future<List<QuestionModel>?> getQuestion() async {
    var clientls = http.Client();
    var urils = Uri.parse('http://localhost:3106/api/question');
    try {
      var response = await clientls.get(urils);
      // print("zzzzz");
      if (response.statusCode == 200) {
        var json = response.body;
        return questionFromJson(json);
      } else {
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Network error: $e');
    } finally {
      clientls.close();
    }
    return null;
  }

  Future<bool> deleteQuestion(String id) async {
    var client = http.Client();
    var uri = Uri.parse('http://localhost:3106/api/question/$id');

    try {
      var response = await client.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Question deleted successfully.');
        return true;
      } else {
        print('Failed to delete question. Status code: ${response.statusCode}');
        print('Error response: ${response.body}');
      }
    } catch (e) {
      print('Error deleting question: $e');
    } finally {
      client.close();
    }
    return false;
  }
}
