import 'dart:convert';

import 'package:admin/models/question_model.dart';

List<Survey> postFromJson(String str) {
  final jsonData = json.decode(str);
  return List<Survey>.from(jsonData['surveys'].map((x) => Survey.fromJson(x)));
}

String postToJson(List<Survey> data) =>
    jsonEncode({"surveys": List<dynamic>.from(data.map((x) => x.toJson()))});

class Survey {
  int surveyId;
  bool surveyStatus;
  String surveyName;
  String surveyDescription;
  DateTime surveyStartDate;
  DateTime surveyEndDate;
  List<Question> questions;

  Survey({
    required this.surveyId,
    required this.surveyStatus,
    required this.surveyName,
    required this.surveyDescription,
    required this.surveyStartDate,
    required this.surveyEndDate,
    required this.questions,
  });

  factory Survey.fromJson(Map<String, dynamic> json) {
    return Survey(
      surveyId: json['survey_id'],
      surveyStatus: json['survey_status'],
      surveyName: json['survey_name'],
      surveyDescription: json['survey_description'],
      surveyStartDate: DateTime.parse(json['survey_start_date']),
      surveyEndDate: DateTime.parse(json['survey_end_date']),
      questions: (json['questions'] as List<dynamic>)
          .map((questionJson) => Question.fromJson(questionJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'survey_id': surveyId,
      'survey_status': surveyStatus,
      'survey_name': surveyName,
      'survey_description': surveyDescription,
      'survey_start_date': surveyStartDate.toIso8601String(),
      'survey_end_date': surveyEndDate.toIso8601String(),
      'questions': questions.map((question) => question.toJson()).toList(),
    };
  }
}
