import 'package:admin/screens/answers.dart';
import 'package:flutter/material.dart';
import 'package:admin/models/all_survey_model.dart';
import 'package:admin/services/all_survey.dart';

class ConsumerAnswer extends StatefulWidget {
  const ConsumerAnswer({super.key});

  @override
  ConsumerAnswerWidgetState createState() => ConsumerAnswerWidgetState();
}

class ConsumerAnswerWidgetState extends State<ConsumerAnswer> {
  List<AllSurvey>? allSurveys;
  bool isLoaded = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      allSurveys = await AllSurveyRemoteService().getAllSurvey();
      if (allSurveys != null && allSurveys!.isNotEmpty) {
        setState(() {
          isLoaded = true;
        });
      }
    } catch (e) {
      print('Error fetching surveys: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff333541),
          centerTitle: true,
          title: const Text(
            "Survey",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: isLoaded
                ? ClipRect(
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 300,
                        childAspectRatio: 2 / 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemCount: allSurveys!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SavedAnswers(
                                          id: allSurveys![index].id,
                                          name: allSurveys![index].surveyName,
                                        )));
                          },
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  color: Colors.black.withOpacity(0.5),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // NetworkImage(allSurveys![index].imgUrl),
                                        // Image.network(
                                        //   allSurveys![index].imgUrl,
                                        //   width: 150,
                                        //   height: 150,
                                        // ),
                                        Text(
                                          "Survey Name: ${allSurveys![index].surveyName}",
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        // Text("${allSurveys![index].id}")
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ));
  }
}
