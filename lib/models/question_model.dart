import 'dart:convert';

import 'package:admin/models/question_type_model.dart';

class Question {
  final int questionsID;
  final String questionsTypeID;
  final String questionText;
  final String surveyID;
  final bool isMandatory;

  Question({
    required this.questionsID,
    required this.questionsTypeID,
    required this.questionText,
    required this.surveyID,
    required this.isMandatory,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionsID: json['questions_id'],
      questionsTypeID: json['questions_type_id'],
      questionText: json['question_text'] as String,
      surveyID: json['survey_id'] as String,
      isMandatory: json['is_Mandatory'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        "questions_id": questionsID,
        "questions_type_id": questionsTypeID,
        "question_text": questionText,
        "survey_id": surveyID,
        "is_Mandatory": isMandatory,
      };
}

List<Question> questionFromJson(String str) {
  final jsonData = json.decode(str);
  return List<Question>.from(
    jsonData["question"].map((x) => Question.fromJson(x)),
  );
}

String questionToJson(List<Question> data) =>
    json.encode({"question": List<dynamic>.from(data.map((x) => x.toJson()))});
