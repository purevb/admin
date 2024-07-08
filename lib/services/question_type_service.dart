import 'package:admin/models/question_type_model.dart';
import 'package:http/http.dart' as http;

class TypesRemoteService {
  Future<List<QuestionType>?> getType() async {
    var clientr = http.Client();
    var urir = Uri.parse('http://localhost:3106/api/type');
    try {
      var response = await clientr.get(urir);
      if (response.statusCode == 200) {
        var json = response.body;
        return typeFromJson(json);
      } else {
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    } finally {
      clientr.close();
    }
    return null;
  }
}
