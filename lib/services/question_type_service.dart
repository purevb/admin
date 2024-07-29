import 'package:admin/models/question_type_model.dart';
import 'package:http/http.dart' as http;

class TypesRemoteService {
  Future<List<QuestionType>> getType() async {
    var client = http.Client();
    var uri = Uri.parse('http://localhost:3106/api/type');

    try {
      var response = await client.get(uri);
      if (response.statusCode == 200) {
        var json = response.body;
        return typeFromJson(json);
      } else {
        print('Server error: ${response.statusCode}');
        throw Exception('Failed to load types from API');
      }
    } catch (e) {
      print('Network error: $e');
      throw e;
    } finally {
      client.close();
    }
  }
}
