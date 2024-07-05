import 'dart:convert';

List<Answer> postFromJson(String str) {
  final jsonData = json.decode(str);
  return List<Answer>.from(jsonData['answer'].map((x) => Answer.fromJson(x)));
}

String postToJson(List<Answer> data) =>
    json.encode({"answer": List<dynamic>.from(data.map((x) => x.toJson()))});

class Answer {
  final int answersId;
  final String questionsId;
  final String answerText;

  const Answer({
    required this.answersId,
    required this.questionsId,
    required this.answerText,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      answersId: json['answersId'],
      questionsId: json['questionsId'],
      answerText: json['answerText'],
    );
  }

  Map<String, dynamic> toJson() => {
        "answersId": answersId,
        "questionsId": questionsId,
        "answerText": answerText
      };
}
