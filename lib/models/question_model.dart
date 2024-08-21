import 'dart:convert';
class AnswerModel {
  final String answerText;

  AnswerModel({
    required this.answerText,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      answerText: json['answer_text'] ?? '',  // Providing a default empty string if null
    );
  }

  Map<String, dynamic> toJson() => {
        "answer_text": answerText,
      };
}

class QuestionModel {
  String? id;
  final String surveyID;
  final String? questionsTypeID;
  final String? questionText;
  final List<AnswerModel> answers;  // No need to be nullable if handled properly
  final bool? isMandatory;

  QuestionModel({
    required this.surveyID,
    this.id,
    this.questionsTypeID,
    this.questionText,
    this.answers = const [],  // Initialize with an empty list if null
    this.isMandatory,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    var answersFromJson = json['answers'] as List<dynamic>?;

    return QuestionModel(
      surveyID: json['surveyID'] as String,
      id: json['_id'] as String?,  // Make sure this matches your JSON key
      questionsTypeID: json['questions_type_id'] as String?,
      questionText: json['question_text'] as String?,
      answers: answersFromJson != null
          ? answersFromJson.map((answer) => AnswerModel.fromJson(answer)).toList()
          : [],
      isMandatory: json['is_Mandatory'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "surveyID": surveyID,
        "questions_type_id": questionsTypeID,
        "question_text": questionText,
        "answers": List<dynamic>.from(answers.map((x) => x.toJson())),
        "is_Mandatory": isMandatory,
      };
}

List<QuestionModel> questionFromJson(String str) {
  final jsonData = json.decode(str);
  return List<QuestionModel>.from(
    jsonData["question"].map((x) => QuestionModel.fromJson(x)),
  );
}

String questionToJson(List<QuestionModel> data) =>
    json.encode({"question": List<dynamic>.from(data.map((x) => x.toJson()))});
