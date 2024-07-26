import 'package:admin/models/question_model.dart';
import 'package:flutter/material.dart';

class QuestionProvider extends ChangeNotifier {
  List<Widget> quests = [];
  List<QuestionModel?> questions = [];
  List<String> answerID = [];
  // List<String> typeID = [];

  void addAnswerIdData(String id) {
    answerID.add(id);
    print('Added question: ${id}');
    notifyListeners();
  }

  void addQuestionData(QuestionModel question) {
    questions.add(question);
    print('Added question: ${question.toJson()}');
    notifyListeners();
  }

  void addQuestion(Widget widget) {
    quests.add(widget);
    notifyListeners();
  }

  void removeQuestion(Widget widget) {
    quests.remove(widget);
    notifyListeners();
  }
}
