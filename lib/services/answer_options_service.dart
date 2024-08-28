import 'package:admin/models/answer_options.dart';
import 'package:http/http.dart' as http;

class AnswerOptionsRemoteService {
  Future<List<AnswerOptions>?> getAnswerOptions() async {
    var clientls = http.Client();
    var urils = Uri.parse('http://localhost:3106/api/aoptions');
    try {
      var response = await clientls.get(urils);
      if (response.statusCode == 200) {
        var json = response.body;
        return typeFromJson(json);
      } else {
        print('Server errorsad : ${response.statusCode}');
      }
    } catch (e) {
      print('Network error: $e');
    } finally {
      clientls.close();
    }
    return null;
  }
}
