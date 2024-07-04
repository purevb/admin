import 'package:flutter/material.dart';

class QuestionWidget extends StatefulWidget {
  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

List<String> list = <String>[
  'Logical',
  'Single Choice',
  'Multiple Choice',
  'Numeric',
  'Text'
];

class _QuestionWidgetState extends State<QuestionWidget> {
  String dropdownValue = list.first;
  DateTime? selectedDate;
  int _selectedValue = 1;
  int number = 1;
  List<TextEditingController> _controllers = [];
  List<int> _values = [];
  List<bool> _isChecked = [];
  List<Widget> quests = [];

  void addOptions() {
    setState(() {
      _controllers.add(TextEditingController(text: "Option $number"));
      _isChecked.add(false);
      _values.add(_values.length + 1);
      number++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.grey.withOpacity(0.08),
                  child: TextFormField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      labelText: "Асуулт",
                      labelStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.image_outlined,
                  size: 30,
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 5, right: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_drop_down),
                  elevation: 16,
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          Column(
            children: List.generate(_controllers.length, (index) {
              if (dropdownValue == "Multiple Choice") {
                return Container(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _isChecked[index],
                        activeColor: Colors.amber,
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked[index] = value!;
                          });
                        },
                      ),
                      Expanded(
                        child: TextField(
                          controller: _controllers[index],
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _controllers.removeAt(index);
                            _isChecked.removeAt(index);
                          });
                        },
                        icon: Icon(Icons.cancel_outlined),
                      ),
                    ],
                  ),
                );
              } else {
                return Container(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Radio(
                        value: _values[index],
                        groupValue: _selectedValue,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedValue = value!;
                          });
                        },
                      ),
                      Expanded(
                        child: TextField(
                          controller: _controllers[index],
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _controllers.removeAt(index);
                            _values.removeAt(index);
                          });
                        },
                        icon: Icon(Icons.cancel_outlined),
                      ),
                    ],
                  ),
                );
              }
            }),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: InkWell(
                onTap: addOptions,
                child: Row(
                  children: [
                    Radio(
                      value: 50,
                      groupValue: _selectedValue,
                      onChanged: (int? value) {
                        setState(() {
                          _selectedValue = value!;
                        });
                      },
                    ),
                    Text(
                      "Add option",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
