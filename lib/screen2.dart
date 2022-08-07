import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class Screen2 extends StatefulWidget {
  const Screen2({Key? key}) : super(key: key);

  @override
  _Screen2State createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  late final String name;
  var nameController = TextEditingController();
  var dateController = TextEditingController();
  var sidController = TextEditingController();
  var remarksController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final databaseRef = FirebaseDatabase.instance.reference();
  late String date1 = 'N/A';

  @override
  Widget textform() {
    date1 = 'N/A';
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              style: TextStyle(color: Colors.blueAccent),
              controller: nameController,
              decoration: const InputDecoration(
                  hintText: ' Enter Tool',
                  hintStyle: TextStyle(
                    color: Colors.black54,
                  )),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Enter Tool';
                }
                return null;
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  style: TextStyle(color: Colors.blueAccent),
                  controller: sidController,
                  decoration: const InputDecoration(
                      hintText: ' Enter Material Number',
                      hintStyle: TextStyle(
                        color: Colors.black54,
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Material Number';
                    }
                    return null;
                  },
                ),
                Column(
                  children: [
                    TextFormField(
                      style: TextStyle(color: Colors.blueAccent),
                      controller: remarksController,
                      decoration: const InputDecoration(
                          hintText: ' Add Remarks (Optional)',
                          hintStyle: TextStyle(
                            color: Colors.black54,
                          )),
                    ),
                  ],
                ),
                TextButton(
                    onPressed: () {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(1974, 1, 1),
                          maxTime: DateTime(2100, 1, 1),
                          theme: DatePickerTheme(
                              headerColor: Colors.white,
                              backgroundColor: Colors.white,
                              itemStyle: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                              doneStyle:
                                  TextStyle(color: Colors.blueAccent, fontSize: 16)),
                          onChanged: (date) {
                        print('change $date in time zone ' +
                            date.timeZoneOffset.inHours.toString());
                      }, onConfirm: (date) {
                        print('confirm $date');
                        date1 = '${date.day}-${date.month}-${date.year}';
                      });
                    },
                    child: Text(
                      'Expiry Date',
                      style: TextStyle(color: Colors.blue),
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() || date1.isNotEmpty) {
                    _showMyDialog();
                  } else {
                    ;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please try again')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 90.0, left: 25.0, right: 15.0, bottom: 15.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Text("  Add Tools",
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              textform(),
            ]),
          ),
        ),
      ),
    );
  }

  void insertData(String name, String sid, String remarks, String date1) {
    String key = databaseRef.child("tools").push().key;
    databaseRef.child("tools").push().set({
      'id': key,
      'name': name,
      'sid': sid,
      'remarks': remarks,
      'date': date1,
    });

    nameController.clear();
    dateController.clear();
    sidController.clear();
    remarksController.clear();
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm!'),
          content: SingleChildScrollView(
            child: Text('Are you sure you want to Confirm?'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                Navigator.pop(context);
                insertData(nameController.text, sidController.text,
                    remarksController.text, date1);
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
