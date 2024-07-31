import 'dart:convert';

class Answer {
  final String id;
  final String answerText;

  Answer({
    required this.id,
    required this.answerText,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['_id'] ?? '',
      answerText: json['answer_text'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "answer_text": answerText,
      };
}

class Question {
  final String id;
  final String questionText;
  final List<Answer> answerText;

  Question({
    required this.id,
    required this.questionText,
    required this.answerText,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    var answerFromJson = json['answer_text'] as List? ?? [];
    List<Answer> answerList =
        answerFromJson.map((answer) => Answer.fromJson(answer)).toList();
    return Question(
      id: json['_id'] ?? '',
      questionText: json['question_text'] ?? '',
      answerText: answerList,
    );
  }

  Map<String, dynamic> toJson() =>
      {"question_text": questionText, "answer_text": answerText};
}

class AllSurvey {
  final String id;
  final String surveyName;
  final String surveyDescription;
  final DateTime startDate;
  final DateTime endDate;
  final bool surveyStatus;
  final String imgUrl;

  final List<Question> question;

  AllSurvey(
      {required this.id,
      required this.surveyName,
      required this.surveyDescription,
      required this.startDate,
      required this.endDate,
      required this.surveyStatus,
      required this.question,
      required this.imgUrl});

  factory AllSurvey.fromJson(Map<String, dynamic> json) {
    var questionFromJson = json['questions'] as List? ?? [];
    List<Question> questionList = questionFromJson
        .map((question) => Question.fromJson(question))
        .toList();

    return AllSurvey(
      id: json['_id'] ?? '',
      surveyName: json['survey_name'] ?? '',
      surveyDescription: json['survey_description'] ?? '',
      startDate: DateTime.parse(json['survey_start_date']),
      endDate: DateTime.parse(json['survey_end_date']),
      surveyStatus: json['survey_status'] ?? false,
      imgUrl: json['img_url'],
      question: questionList,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'survey_name': surveyName,
        'survey_description': surveyDescription,
        'survey_start_date': startDate.toIso8601String(),
        'survey_end_date': endDate.toIso8601String(),
        'survey_status': surveyStatus,
        'img_url': imgUrl,
        'questions': question.map((q) => q.toJson()).toList(),
      };
}

List<AllSurvey> allSurveyFromJson(String str) {
  final jsonData = json.decode(str);
  return List<AllSurvey>.from(jsonData.map((item) => AllSurvey.fromJson(item)));
}

String allSurveyToJson(List<AllSurvey> data) {
  return json.encode(List<dynamic>.from(data.map((item) => item.toJson())));
}
