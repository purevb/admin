import 'package:admin/admin.dart';
import 'package:admin/models/all_survey_model.dart';
import 'package:admin/screens/costumer_answers.dart';
import 'package:admin/screens/survey_details.dart';
import 'package:admin/services/all_survey.dart';
import 'package:flutter/material.dart';

class AllSurveys extends StatefulWidget {
  const AllSurveys({super.key});
  @override
  AllSurveyWidgetState createState() => AllSurveyWidgetState();
}

class AllSurveyWidgetState extends State<AllSurveys> {
  bool isMandatory = false;

  List<AllSurvey>? allSurveys;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    allSurveys = await AllSurveyRemoteService().getAllSurvey();
    if (allSurveys != null && allSurveys!.isNotEmpty) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  Future<void> deleteSurvey(String id) async {
    try {
      await AllSurveyRemoteService().deleteSurvey(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Survey deleted succesfully')),
      );
      getData();
    } catch (e) {
      print('Error deleting survey');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delet Survey')),
      );
    }
  }

  Future<void> _dialogBuilder(BuildContext context, String id) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Асуулт устгах"),
            content: const Text("Асуулт устгах зөвшөөрөл!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Үгүй"),
              ),
              TextButton(
                onPressed: () {
                  deleteSurvey(id);
                },
                child: const Text("Тийм"),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff333541),
        centerTitle: true,
        title: const Text(
          "All surveys",
          style: TextStyle(color: Colors.white),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.only(left: 10, top: 8, bottom: 8),
              child: Container(
                color: const Color(0xff8146f6),
                child: IconButton(
                  iconSize: 23,
                  icon: const Icon(Icons.question_answer_sharp),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ConsumerAnswer()));
                  },
                ),
              ),
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Container(
              color: const Color(0xff8146f6),
              child: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminDash(),
                    ),
                  );
                },
                tooltip: "Create Survey",
                color: Colors.black,
              ),
            ),
          )
        ],
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
                              builder: (context) => SurveyDetailWidget(
                                id: allSurveys![index].id,
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                color: Colors.black.withOpacity(0.5),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
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
                            Positioned(
                                right: 0,
                                bottom: 0,
                                child: IconButton(
                                    onPressed: () {
                                      _dialogBuilder(
                                          context, allSurveys![index].id);
                                      // deleteSurvey(allSurveys![index].id);
                                    },
                                    icon: const Icon(Icons.delete_forever)))
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
      ),
    );
  }
}
