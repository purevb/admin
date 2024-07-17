// import 'dart:convert';

// class Answer {
//   final int answersId;
//   final String questionsId;
//   final String answerText;

//   const Answer({
//     required this.answersId,
//     required this.questionsId,
//     required this.answerText,
//   });

//   factory Answer.fromJson(Map<String, dynamic> json) {
//     return Answer(
//       answersId: json['answers_id'],
//       questionsId: json['questions_id'],
//       answerText: json['answer_text'],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "answers_id": answersId,
//         "questions_id": questionsId,
//         "answer_text": answerText
//       };
// }

// List<Answer> postFromJson(String str) {
//   final jsonData = json.decode(str);
//   return List<Answer>.from(jsonData["answer"].map((x) => Answer.fromJson(x)));
// }

// String postToJson(List<Answer> data) =>
//     json.encode({"answer": List<dynamic>.from(data.map((x) => x.toJson()))});
