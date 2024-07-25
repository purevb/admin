import 'package:admin/models/all_survey_model.dart';
import 'package:admin/models/survey_model.dart';
import 'package:admin/provider/question_provider.dart';
import 'package:admin/screens/allSurveys.dart';
import 'package:admin/screens/quest.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestionWidget extends StatefulWidget {
  final Survey survey;
  final String id;

  QuestionWidget({Key? key, required this.survey, required this.id})
      : super(key: key);

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  final _formKey = GlobalKey<FormState>();
  bool isMandatory = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
                  MaterialPageRoute(builder: (context) => AllSurveys()));
            },
            child: const Text("Surveys"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff333541),
              foregroundColor: Colors.white,
            ),
          ),
          SizedBox(
            width: width * 0.2,
          ),
          const Placeholder(
            fallbackHeight: 30,
            fallbackWidth: 100,
          ),
          const SizedBox(
            width: 20,
          ),
          const Placeholder(
            fallbackHeight: 30,
            fallbackWidth: 100,
          ),
          const SizedBox(
            width: 20,
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
      body: Form(
        key: _formKey,
        child: Row(
          children: [
            Container(
              width: width * 0.3,
              height: height + 20,
              color: const Color.fromARGB(255, 59, 59, 57),
              child: SurveyDetails(survey: widget.survey),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20, left: 20),
              width: width * 0.7 - 30,
              height: height,
              child: Consumer<QuestionProvider>(
                builder: (context, questionProvider, child) {
                  return ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return questionProvider.quests[index];
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(
                      height: 10,
                    ),
                    itemCount: questionProvider.quests.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // List<Answer> answers = ans.map((e) => Answer(answerText: e)).toList();
          // for (var type in pastTypes!) {
          //   if (dropdownValue == type.questionType) {
          //     asuult.add(
          //       Question(
          //         surveyID: widget.id,
          //         questionsTypeID: type.id ?? "",
          //         questionText: ques,
          //         isMandatory: isMandatory,
          //         answers: answers,
          //       ),
          //     );
          //     break;
          //   }
          // }
          // if (asuult.isNotEmpty) {
          //   postQuestion(asuult);
          // } else {
          //   print('Question type taarsngu.');
          // }
        },
        child: const Icon(Icons.save),
        backgroundColor: const Color(0xff15ae5c),
        tooltip: "Save all questions",
      ),
    );
  }
}

class SurveyDetails extends StatelessWidget {
  final Survey survey;
  const SurveyDetails({Key? key, required this.survey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Survey Name: ${survey.surveyName}",
            style: TextStyle(color: Colors.white),
          ),
          Text("Survey description: ${survey.surveyDescription}",
              style: TextStyle(color: Colors.white)),
          Text("Survey status: ${survey.surveyStatus}",
              style: TextStyle(color: Colors.white)),
          Text(
              "Survey start date: ${survey.surveyStartDate.toString().split(" ")[0]}",
              style: TextStyle(color: Colors.white)),
          Text(
              "Survey end date: ${survey.surveyEndDate.toString().split(' ')[0]}",
              style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
