import 'package:flutter/material.dart';
import 'package:admin/models/all_survey_model.dart';
import 'package:admin/services/all_survey.dart';

class EditSurveyDetailWidget extends StatefulWidget {
  final String id;

  EditSurveyDetailWidget({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _EditSurveyDetailWidgetState createState() => _EditSurveyDetailWidgetState();
}

class _EditSurveyDetailWidgetState extends State<EditSurveyDetailWidget> {
  List<AllSurvey>? allSurveys;
  bool isLoaded = false;
  final TextEditingController surveyNameController = TextEditingController();
  final TextEditingController surveyDescriptionController =
      TextEditingController();
  final TextEditingController surveyStartDayController =
      TextEditingController();
  final TextEditingController surveyEndDayController = TextEditingController();
  late List<QuestionEditor> questionEditors;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    surveyNameController.dispose();
    surveyDescriptionController.dispose();
    surveyStartDayController.dispose();
    surveyEndDayController.dispose();
    super.dispose();
  }

  Future<void> getData() async {
    try {
      List<AllSurvey>? surveys = await AllSurveyRemoteService().getAllSurvey();
      setState(() {
        allSurveys = surveys;
        isLoaded = true;

        if (allSurveys != null && allSurveys!.isNotEmpty) {
          AllSurvey currentSurvey =
              allSurveys!.firstWhere((survey) => survey.id == widget.id);
          surveyNameController.text = currentSurvey.surveyName;
          surveyDescriptionController.text = currentSurvey.surveyDescription;
          surveyStartDayController.text = currentSurvey.startDate.toString();
          surveyEndDayController.text = currentSurvey.endDate.toString();

          questionEditors = currentSurvey.question
              .map((question) => QuestionEditor(question: question))
              .toList();
        }
      });
    } catch (e) {
      print('Error fetching surveys: $e');
    }
  }

  Future<void> updateSurveyAndQuestions() async {
    try {
      // Update survey details
      final updatedSurvey = {
        "survey_name": surveyNameController.text,
        "survey_description": surveyDescriptionController.text,
        "survey_start_date": surveyStartDayController.text,
        "survey_end_date": surveyEndDayController.text,
      };

      final surveyResponse =
          await AllSurveyRemoteService().updateSurvey(widget.id, updatedSurvey);

      bool questionsUpdated = true;
      for (var editor in questionEditors) {
        print(questionEditors.length);
        print(editor.questionTextController.text);
        final updatedQuestion = {
          "question_text": editor.questionTextController.text,
        };
        final questionResponse = await AllSurveyRemoteService()
            .updateQuestion(editor.question.id, updatedQuestion);
        if (!questionResponse) {
          questionsUpdated = false;
        }

        // for (var answerEditor in editor.answerEditors) {
        //   final updatedAnswer = {
        //     "answer_text": answerEditor.answerTextController.text,
        //   };
        //   // Ensure you have a correct method to update the answer
        //   final answerResponse = await AllSurveyRemoteService()
        //       .updater(answerEditor.answer.id, updatedAnswer);
        //   if (!answerResponse) {
        //     questionsUpdated = false;
        //   }
        // }
      }
      if (surveyResponse && questionsUpdated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Survey and questions updated successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update survey or questions')),
        );
      }
    } catch (e) {
      print('Error updating survey or questions: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update survey or questions')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff333541),
        centerTitle: true,
        title: const Text(
          "Edit Survey",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            color: Colors.white,
            onPressed: updateSurveyAndQuestions,
          ),
        ],
      ),
      body: isLoaded
          ? (allSurveys != null && allSurveys!.isNotEmpty
              ? ListView.builder(
                  itemCount: allSurveys!.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (allSurveys![index].id == widget.id) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: surveyNameController,
                              decoration: const InputDecoration(
                                  labelText: 'Survey Name'),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: surveyDescriptionController,
                              decoration: const InputDecoration(
                                  labelText: 'Survey Description'),
                            ),
                            const SizedBox(height: 16),
                            const Text('Survey Questions:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic)),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: surveyStartDayController,
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101),
                                );
                                if (pickedDate != null) {
                                  setState(() {
                                    surveyStartDayController.text = pickedDate
                                        .toIso8601String()
                                        .split('T')
                                        .first;
                                  });
                                }
                              },
                              decoration: const InputDecoration(
                                labelText: "Start Date",
                                border: OutlineInputBorder(),
                              ),
                              validator: (date) => date == null || date.isEmpty
                                  ? "Start date is required"
                                  : null,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: surveyEndDayController,
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101),
                                );
                                if (pickedDate != null) {
                                  setState(() {
                                    surveyEndDayController.text = pickedDate
                                        .toIso8601String()
                                        .split('T')
                                        .first;
                                  });
                                }
                              },
                              decoration: const InputDecoration(
                                labelText: "End Date",
                                border: OutlineInputBorder(),
                              ),
                              validator: (date) => date == null || date.isEmpty
                                  ? "End date is required"
                                  : null,
                            ),
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: questionEditors.map((editor) {
                                return editor;
                              }).toList(),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                )
              : const Center(child: Text('No surveys available')))
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class QuestionEditor extends StatelessWidget {
  final Question question;
  final TextEditingController questionTextController = TextEditingController();
  late List<AnswerEditor> answerEditors;

  QuestionEditor({super.key, required this.question}) {
    questionTextController.text = question.questionText;
    answerEditors = question.answerText
        .map((answer) => AnswerEditor(answer: answer))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.only(right: 5, left: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: questionTextController,
            decoration: const InputDecoration(labelText: 'Question Text'),
          ),
          const SizedBox(height: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: answerEditors,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class AnswerEditor extends StatelessWidget {
  final Answer answer;
  final TextEditingController answerTextController = TextEditingController();

  AnswerEditor({super.key, required this.answer}) {
    answerTextController.text = answer.answerText;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: answerTextController,
      decoration: const InputDecoration(labelText: 'Answer Text'),
    );
  }
}
