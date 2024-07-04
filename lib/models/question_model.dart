import 'package:admin/models/answer_model.dart';

class Question {
  int questionsId;
  String questionsTypeId;
  String questionText;
  String surveyId;
  bool isMandatory;
  List<Answer> answers;

  Question({
    required this.questionsId,
    required this.questionsTypeId,
    required this.questionText,
    required this.surveyId,
    required this.isMandatory,
    required this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionsId: json['questions_id'],
      questionsTypeId: json['questions_type_id'],
      questionText: json['question_text'],
      surveyId: json['survey_id'],
      isMandatory: json['is_Mandatory'],
      answers: (json['answers'] as List<dynamic>)
          .map((answerJson) => Answer.fromJson(answerJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questions_id': questionsId,
      'questions_type_id': questionsTypeId,
      'question_text': questionText,
      'survey_id': surveyId,
      'is_Mandatory': isMandatory,
      'answers': answers.map((answer) => answer.toJson()).toList(),
    };
  }
}
