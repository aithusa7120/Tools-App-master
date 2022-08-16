import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class details extends StatefulWidget {
  String contactKey;

  details({required this.contactKey});

  @override
  _detailsState createState() => _detailsState();
}

class _detailsState extends State<details> {
  late TextEditingController _nameController,_numberController,_remarksController,_dateController;
  String _typeSelected = '';

  late DatabaseReference _ref;
  late String date1 = 'N/A';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = TextEditingController();
    _dateController = TextEditingController();
    _numberController = TextEditingController();
    _remarksController = TextEditingController();
    late String date1 = 'N/A';
    _ref = FirebaseDatabase.instance.reference().child('tools');
    getContactDetail();
  }

  Widget _buildContactType(String title) {
    return InkWell(
      child: Container(
        height: 40,
        width: 90,
        decoration: BoxDecoration(
          color: _typeSelected == title
              ? Colors.green
              : Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
      onTap: () {
        setState(() {
          _typeSelected = title;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Tool'),
      ),
      body: Container(

        margin: EdgeInsets.all(15),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            SizedBox(height: 15),
            TextFormField(
              controller: _numberController,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.phone_iphone,
                  size: 30,
                ),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.all(15),
              ),
            ),

            SizedBox(height: 15),
            TextFormField(
              controller: _remarksController,
              decoration: InputDecoration(
                hintText: 'Remarks',
                prefixIcon: Icon(
                  Icons.add,
                  size: 30,
                ),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.all(15),
              ),
            ),
            SizedBox(
              height: 15,
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
            SizedBox(
              height: 25,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: RaisedButton(
                child: Text(
                  'Update Details',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  saveContact();
                },
                color: Theme.of(context).primaryColor,
              ),
            )

          ],

        ),
      ),
    );
  }

  getContactDetail() async {
    DataSnapshot snapshot = await _ref.child(widget.contactKey).once();

    Map contact = snapshot.value;

    _nameController.text = contact['name'];
    _numberController.text = contact['sid'];
    _remarksController.text = contact['remarks'];
    _dateController = contact ['date'];


    setState(() {
      _typeSelected = contact['type'];
    });
  }

  void saveContact() {
    String name1 = _nameController.text;
    String sid = _numberController.text;
    String remarks = _remarksController.text;
    Map<String, String> contact = {
      'name': name1,
      'sid': sid,
      'date': date1,
      'remarks': remarks,
      'type': _typeSelected,
    };

    _ref.child(widget.contactKey).update(contact).then((value) {
      Navigator.pop(context);
    });
  }
}
