// import 'package:admin/models/answer_model.dart';
// import 'package:http/http.dart' as http;

// class RemoteService {
//   Future<List<Answer>?> getAnswer() async {
//     var client = http.Client();
//     var uri = Uri.parse('http://localhost:3106/api/answer');
//     try {
//       var response = await client.get(uri);
//       if (response.statusCode == 200) {
//         var json = response.body;
//         return postFromJson(json);
//       } else {
//         print('Server error: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Network error: $e');
//     } finally {
//       client.close();
//     }
//     return null;
//   }
// }
