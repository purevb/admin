import 'package:admin/models/question_model.dart';
import 'package:flutter/material.dart';

class QuestionProvider extends ChangeNotifier {
  List<Widget> quests = [];
  List<Question>? asuult = [];

  void addQuestion(Widget widget) {
    quests.add(widget);
    notifyListeners();
  }

  void removeQuestion(Widget widget) {
    quests.remove(widget);
    notifyListeners();
  }
}
