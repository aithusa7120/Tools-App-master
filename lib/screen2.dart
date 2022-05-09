import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:toolapp/homepage.dart';



class Screen2 extends StatefulWidget {
  const Screen2({Key? key}) : super(key: key);

  @override
  _Screen2State createState() => _Screen2State();

}

class _Screen2State extends State<Screen2> {
  late final String name;
  var nameController = new TextEditingController();
  var dateController = new TextEditingController();
  var sidController = new TextEditingController();
  var remarksController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final databaseRef= FirebaseDatabase.instance.reference();
  late String date1 = 'N/A';




  @override



  Widget textform(){
    date1 = 'N/A';
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              style: TextStyle(color: Colors.white),
              controller: nameController,
              decoration: const InputDecoration(
                  hintText: ' Enter Tool',
                  hintStyle: TextStyle(
                    color: Colors.white,
                  )
              ),
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
                  style: TextStyle(color: Colors.white),
                  controller: sidController,
                  decoration: const InputDecoration(
                      hintText: ' Enter Material Number',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      )
                  ),
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
                      style: TextStyle(color: Colors.white),
                      controller: remarksController,
                      decoration: const InputDecoration(
                          hintText: ' Add Remarks (Optional)',
                          hintStyle: TextStyle(
                            color: Colors.white,
                          )
                      ),

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
                              headerColor: Colors.grey,
                              backgroundColor: Colors.black,
                              itemStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                              doneStyle:
                              TextStyle(color: Colors.white, fontSize: 16)),

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

                    )

                ),

              ],

            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),

              child: ElevatedButton(

                onPressed: () {
                  if (_formKey.currentState!.validate()||date1.isNotEmpty) {
                    _showMyDialog();

                  }

                else {
                    ;ScaffoldMessenger.of(context).showSnackBar(
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
        color: Colors.grey[900],
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.only(top: 90.0, left : 25.0, right: 15.0, bottom: 15.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Text(
                        "    Add Tools",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        )
                    ),
                  ),
                  textform(),
                ]
            ),
          ),
        ),
      ),

    );
  }
  void insertData(String  name, String sid, String remarks, String date1){


    String key = databaseRef.child("tools").push().key;
    databaseRef.child("tools").push().set({
      'id': key,
      'name':name,
      'sid':sid,
      'remarks': remarks,
      'date': date1,
    }
    );

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
                  insertData(nameController.text, sidController.text, remarksController.text, date1);






              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: (){
                Navigator.pop(context);

              },
            )
          ],
        );
      },
    );
  }
}