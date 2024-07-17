import 'dart:convert';

class Answer {
  final int answersID;
  final String answerText;

  Answer({
    required this.answersID,
    required this.answerText,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      answersID: json['answers_id'],
      answerText: json['answer_text'],
    );
  }

  Map<String, dynamic> toJson() => {
        "answers_id": answersID,
        "answer_text": answerText,
      };
}

class Question {
  final int questionsID;
  final String questionsTypeID;
  final String questionText;
  final List<Answer>? answers;
  final bool isMandatory;

  Question({
    required this.questionsID,
    required this.questionsTypeID,
    required this.questionText,
    required this.answers,
    required this.isMandatory,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    var answersFromJson = json['answers'] as List;
    List<Answer> answersList =
        answersFromJson.map((answer) => Answer.fromJson(answer)).toList();

    return Question(
      questionsID: json['questions_id'],
      questionsTypeID: json['questions_type_id'],
      questionText: json['question_text'],
      answers: answersList,
      isMandatory: json['is_Mandatory'],
    );
  }

  Map<String, dynamic> toJson() => {
        "questions_id": questionsID,
        "questions_type_id": questionsTypeID,
        "question_text": questionText,
        "answers": answers != null
            ? List<dynamic>.from(answers!.map((x) => x.toJson()))
            : null,
        "is_Mandatory": isMandatory,
      };
}

List<Question> questionFromJson(String str) {
  final jsonData = json.decode(str);
  return List<Question>.from(
    jsonData["question"].map((x) => Question.fromJson(x)),
  );
}

String questionToJson(List<Question> data) =>
    json.encode({"question": List<dynamic>.from(data.map((x) => x.toJson()))});
