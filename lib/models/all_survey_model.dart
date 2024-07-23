// Dart side
import 'dart:convert';

class Answer {
  final String answerText;

  Answer({
    required this.answerText,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      answerText: json['answer_text'],
    );
  }

  Map<String, dynamic> toJson() => {
        "answer_text": answerText,
      };
}

class AllSurvey {
  final String surveyName;
  final String questionText;
  final List<Answer> answerText;

  AllSurvey({
    required this.surveyName,
    required this.questionText,
    required this.answerText,
  });

  factory AllSurvey.fromJson(Map<String, dynamic> json) {
    var answerTextFromJson = json['answer_text'] as List;
    List<Answer> answerTextList =
        answerTextFromJson.map((answer) => Answer.fromJson(answer)).toList();

    return AllSurvey(
      surveyName: json['survey_name'],
      questionText: json['question_text'],
      answerText: answerTextList,
    );
  }

  Map<String, dynamic> toJson() => {
        'survey_name': surveyName,
        'question_text': questionText,
        'answer_text': answerText.map((answer) => answer.toJson()).toList(),
      };
}

List<AllSurvey> allSurveyFromJson(String str) {
  final jsonData = json.decode(str);
  return List<AllSurvey>.from(jsonData.map((item) => AllSurvey.fromJson(item)));
}

String allSurveyToJson(List<AllSurvey> data) {
  return json.encode(List<dynamic>.from(data.map((item) => item.toJson())));
}
