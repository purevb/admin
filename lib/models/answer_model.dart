class Answer {
  int answersId;
  String questionsId;
  String answerText;

  Answer({
    required this.answersId,
    required this.questionsId,
    required this.answerText,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      answersId: json['answers_id'],
      questionsId: json['questions_id'],
      answerText: json['answer_text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'answers_id': answersId,
      'questions_id': questionsId,
      'answer_text': answerText,
    };
  }
}
