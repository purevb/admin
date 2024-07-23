import 'package:flutter/material.dart';

class QuestionProvider extends ChangeNotifier {
  List<Widget> quests = [];

  void addQuestion(Widget widget) {
    quests.add(widget);
    notifyListeners();
  }

  void removeQuestion(Widget widget) {
    quests.remove(widget);
    notifyListeners();
  }
}
