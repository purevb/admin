import 'package:admin/models/answer_model.dart';
import 'package:admin/models/question_model.dart';

enum QuestionTypeEnum { MultipleChoice, Logical, Numeric, SingleChoice, Text }

class QuestionType {
  int questionsTypeId;
  QuestionTypeEnum questionType;
  List<Question> questions;

  QuestionType({
    required this.questionsTypeId,
    required this.questionType,
    required this.questions,
  });

  factory QuestionType.fromJson(Map<String, dynamic> json) {
    return QuestionType(
      questionsTypeId: json['questions_type_id'],
      questionType: json['question_type'],
      questions: (json['questions'] as List<dynamic>)
          .map((questionJson) => Question.fromJson(questionJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questions_type_id': questionsTypeId,
      'question_type': questionType,
      'questions': questions.map((question) => question.toJson()).toList(),
    };
  }

  String get questionTypeString {
    switch (questionType) {
      case QuestionTypeEnum.MultipleChoice:
        return 'Multiple Choice';
      case QuestionTypeEnum.Logical:
        return 'Logical';
      case QuestionTypeEnum.Numeric:
        return 'Numeric';
      case QuestionTypeEnum.SingleChoice:
        return 'Single Choice';
      case QuestionTypeEnum.Text:
        return 'Text';
    }
  }

  @override
  String toString() {
    return questionTypeString;
  }
}
