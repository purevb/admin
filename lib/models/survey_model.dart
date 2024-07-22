import 'dart:convert';
import 'package:admin/models/question_model.dart';

class Survey {
  String surveyName;
  String surveyDescription;
  DateTime surveyStartDate;
  DateTime surveyEndDate;
  bool surveyStatus;

  Survey({
    required this.surveyName,
    required this.surveyDescription,
    required this.surveyStartDate,
    required this.surveyEndDate,
    required this.surveyStatus,
  });

  factory Survey.fromJson(Map<String, dynamic> json) {
    return Survey(
      surveyName: json['survey_name'],
      surveyDescription: json['survey_description'],
      surveyStartDate: DateTime.parse(json['survey_start_date']),
      surveyEndDate: json['survey_end_date'] != null
          ? DateTime.parse(json['survey_end_date'])
          : DateTime.now(),
      surveyStatus: json['survey_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'survey_name': surveyName,
      'survey_description': surveyDescription,
      'survey_start_date': surveyStartDate.toIso8601String(),
      'survey_end_date': surveyEndDate.toIso8601String(),
      'survey_status': surveyStatus,
    };
  }
}

List<Survey> surveyFromJson(String str) {
  final jsonData = json.decode(str);
  return List<Survey>.from(jsonData["surveys"].map((x) => Survey.fromJson(x)));
}

String surveyToJson(List<Survey> data) =>
    json.encode({"surveys": List<dynamic>.from(data.map((x) => x.toJson()))});
