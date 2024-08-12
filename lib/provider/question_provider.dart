import 'package:admin/models/question_model.dart';
import 'package:flutter/material.dart';

class QuestionProvider extends ChangeNotifier {
  final List<Widget> quests = [];
  final List<QuestionModel?> questions = [];
  final List<String> answerID = [];

  void addAnswerIdData(String id) {
    answerID.add(id);
    print('Added answer ID: $id');
    notifyListeners();
  }

  void addQuestionData(QuestionModel? question) {
    if (question != null) {
      questions.add(question);
      print('Added question: ${question.toJson()}');
      notifyListeners();
    } else {
      print('Attempted to add null question');
    }
  }

  void addQuestion(Widget widget) {
    quests.add(widget);
    notifyListeners();
  }

  void removeQuestion(Widget widget) {
    quests.remove(widget);
    notifyListeners();
  }

  List<QuestionModel?> get allQuestions => questions;
}
