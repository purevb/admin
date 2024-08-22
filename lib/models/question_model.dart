import 'dart:convert';

class AnswerModel {
  final String? id;
  late final String answerText;

  AnswerModel({
    this.id,
    required this.answerText,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      id: json['_id'],
      answerText: json['answer_text'],
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
  final List<AnswerModel>? answers;
  final bool? isMandatory;

  QuestionModel({
    this.id,
    required this.surveyID,
    this.questionsTypeID,
    this.questionText,
    this.answers,
    this.isMandatory,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    var answersFromJson = json['answers'] as List?;
    List<AnswerModel> answersList = answersFromJson != null
        ? answersFromJson.map((answer) => AnswerModel.fromJson(answer)).toList()
        : [];

    return QuestionModel(
      id: json['_id'],
      surveyID: json['surveyID'] ?? "",
      questionsTypeID: json['questions_type_id'] ?? "",
      questionText: json['question_text'] ?? "",
      answers: answersList,
      isMandatory: json['is_Mandatory'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "surveyID": surveyID,
        "questions_type_id": questionsTypeID,
        "question_text": questionText,
        "answers": answers != null
            ? List<dynamic>.from(answers!.map((x) => x.toJson()))
            : null,
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
