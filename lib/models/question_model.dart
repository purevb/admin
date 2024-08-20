import 'dart:convert';

class AnswerModel {
  late final String answerText;

  AnswerModel({
    required this.answerText,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      answerText: json['answer_text'],
    );
  }

  Map<String, dynamic> toJson() => {
        "answer_text": answerText,
      };
}

class QuestionModel {
  late String? id;
  final String surveyID;
  late final String? questionsTypeID;
  late final String? questionText;
  late final List<AnswerModel>? answers;
  late final bool? isMandatory;

  QuestionModel({
    required this.surveyID,
    this.id,
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
      surveyID: json['surveyID'] as String,
      id: json['id'] as String?,
      questionsTypeID: json['questionsTypeID'] as String?,
      questionText: json['questionText'] as String?,
      answers: answersList,
      isMandatory: json['isMandatory'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        "surveyID": surveyID,
        "questions_type_id": questionsTypeID,
        "question_text": questionText,
        "answers": answers != null
            ? List<dynamic>.from(answers!.map((x) => x.toJson()))
            : null,
        "is_Mandatory": isMandatory,
      };

  void removeAt(int optIndex) {}
}

List<QuestionModel> questionFromJson(String str) {
  final jsonData = json.decode(str);
  return List<QuestionModel>.from(
    jsonData["question"].map((x) => QuestionModel.fromJson(x)),
  );
}

String questionToJson(List<QuestionModel> data) =>
    json.encode({"question": List<dynamic>.from(data.map((x) => x.toJson()))});
