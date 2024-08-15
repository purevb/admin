import 'package:admin/models/question_model.dart';
import 'package:flutter/material.dart';

class QuestionProvider extends ChangeNotifier {
  final List<QuestionModel> quests = [];
  final List<Widget> questionWidget = [];
  final List<QuestionModel?> questions = [];
  final List<String> answerID = [];
  void addQuestions(Widget widget) {
    questionWidget.add(widget);
    notifyListeners();
  }

  void removeQuestions(Widget widget) {
    questionWidget.remove(widget);
    notifyListeners();
  }

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

  void addQuestion(QuestionModel question) {
    quests.add(question);
    notifyListeners();
  }

  void removeQuestion(QuestionModel question) {
    quests.remove(question);
    notifyListeners();
  }

  List<QuestionModel?> get allQuestions => questions;
}
