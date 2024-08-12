import 'dart:convert';
import 'package:admin/models/survey_model.dart';
import 'package:admin/provider/question_provider.dart';
import 'package:admin/screens/all_surveys.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'models/question_model.dart';
import 'screens/create_question_cell.dart';

class QuestionWidget extends StatefulWidget {
  final Survey survey;
  final String id;

  const QuestionWidget({super.key, required this.survey, required this.id});

  @override
  QuestionWidgetState createState() => QuestionWidgetState();
}

class QuestionWidgetState extends State<QuestionWidget> {
  void collectSaveQuestions() {
    List<QuestionModel?> allQuestions = [];
    var questionProvider =
        Provider.of<QuestionProvider>(context, listen: false);

    for (var questWidget in questionProvider.quests) {
      final questWidgetState = (questWidget as QuestWidget).createState();
      final questionModel = questWidgetState.getQuestionModel();
      if (questionModel == null) {
        print("Validation failed: Missing required fields");
        return;
      }
      allQuestions.add(questionModel);
    }

    saveQuestionsToBackend(allQuestions.whereType<QuestionModel>().toList());
  }

  void saveQuestionsToBackend(List<QuestionModel> questions) async {
    final url = Uri.parse('http://localhost:3106/api/questions');
    try {
      final questionJson = questions.map((q) => q.toJson()).toList();
      print('Question JSON: $questionJson');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(questionJson),
      );

      if (response.statusCode == 200) {
        print('Questions saved successfully');
      } else {
        print('Failed to save questions. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error occurred while posting questions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff333541),
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AllSurveys()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff333541),
              foregroundColor: Colors.white,
            ),
            child: const Text("Surveys"),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Container(
              color: const Color(0xff8146f6),
              child: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Provider.of<QuestionProvider>(context, listen: false)
                      .addQuestion(QuestWidget(id: widget.id));
                },
                tooltip: "Add Question",
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            color: const Color.fromARGB(255, 59, 59, 57),
            child: SurveyDetails(survey: widget.survey),
          ),
          Container(
            padding: const EdgeInsets.only(top: 20, left: 20, bottom: 60),
            width: MediaQuery.of(context).size.width * 0.7 - 30,
            child: Consumer<QuestionProvider>(
              builder: (context, questionProvider, child) {
                return ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return questionProvider.quests[index];
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 10),
                  itemCount: questionProvider.quests.length,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: collectSaveQuestions,
        backgroundColor: const Color(0xff15ae5c),
        tooltip: "Save all questions",
        child: const Icon(Icons.save),
      ),
    );
  }
}

class SurveyDetails extends StatelessWidget {
  final Survey survey;
  const SurveyDetails({super.key, required this.survey});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Survey Name: ${survey.surveyName}",
            style: const TextStyle(color: Colors.white),
          ),
          Text("Survey description: ${survey.surveyDescription}",
              style: const TextStyle(color: Colors.white)),
          Text("Survey status: ${survey.surveyStatus}",
              style: const TextStyle(color: Colors.white)),
          Text(
              "Survey start date: ${survey.surveyStartDate.toString().split(" ")[0]}",
              style: const TextStyle(color: Colors.white)),
          Text(
              "Survey end date: ${survey.surveyEndDate.toString().split(' ')[0]}",
              style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
