import 'dart:convert';

class AnswerOptions {
  final String surveyId;
  final String id;
  final String questionId;
  final String responseId;
  final List<String>? userChoice;
  final String userId;

  AnswerOptions({
    required this.surveyId,
    required this.id,
    required this.questionId,
    required this.responseId,
    required this.userChoice,
    required this.userId,
  });

  factory AnswerOptions.fromJson(Map<String, dynamic> json) {
    return AnswerOptions(
      surveyId: json['survey_id'] ?? '',
      id: json['_id'] ?? '',
      questionId: json['question_id'] ?? '',
      responseId: json['response_id'] ?? '',
      userChoice: json['user_choice'] != null
          ? List<String>.from(json['user_choice'])
          : null,
      userId: json['user_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'survey_id': surveyId,
      '_id': id,
      'question_id': questionId,
      'response_id': responseId,
      'user_choice': userChoice,
      'user_id': userId,
    };
  }
}

List<AnswerOptions> typeFromJson(String str) {
  final jsonData = json.decode(str);
  return List<AnswerOptions>.from(
      jsonData["aoption"].map((x) => AnswerOptions.fromJson(x)));
}

String typeToJson(List<AnswerOptions> data) =>
    json.encode({"aoption": List<dynamic>.from(data.map((x) => x.toJson()))});