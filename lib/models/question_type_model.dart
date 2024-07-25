// Dart side
import 'dart:convert';

class QuestionType {
  final String? id;
  int questionsTypeId;
  String questionType;

  QuestionType({
    this.id,
    required this.questionsTypeId,
    required this.questionType,
  });

  factory QuestionType.fromJson(Map<String, dynamic> json) {
    return QuestionType(
      id: json['_id'],
      questionsTypeId: json['questions_type_id'],
      questionType: json['question_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questions_type_id': questionsTypeId,
      'question_type': questionType,
    };
  }
}

List<QuestionType> typeFromJson(String str) {
  final jsonData = json.decode(str);
  return List<QuestionType>.from(
      jsonData["type"].map((x) => QuestionType.fromJson(x)));
}

String typeToJson(List<QuestionType> data) =>
    json.encode({"type": List<dynamic>.from(data.map((x) => x.toJson()))});
