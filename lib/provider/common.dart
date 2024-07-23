import 'package:admin/models/question_model.dart';
import 'package:admin/models/question_type_model.dart';
import 'package:admin/models/survey_model.dart';
import 'package:flutter/material.dart';

class CommonProvider extends ChangeNotifier {
  List<Survey>? pastSurveys;
  List<QuestionType>? pastTypes;
  List<Question>? pastQuestions;
}
