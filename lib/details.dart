import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class details extends StatefulWidget {
  String contactKey;

  details({required this.contactKey});

  @override
  _detailsState createState() => _detailsState();
}

class _detailsState extends State<details> {
  late TextEditingController _nameController,_numberController,_remarksController,_imgController;
  String _typeSelected = '';
  late DatabaseReference _ref;
  late String date1 = 'N/A';
  FirebaseStorage storage = FirebaseStorage.instance;
  @override
  void initState() {

    // TODO: implement initState
    super.initState();

    _nameController = TextEditingController();
    _imgController = TextEditingController();
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
        title: Text('Details'),
      ),
      body: Center(

        child: Text(_imgController.text)

        ),

      );

  }

  Widget _imageItem({required Map contact}){
    return Container(
      width: 300,
      height: 250,
      child: Image.network(_imgController.text)
    );
  }

  Widget _buildContactItem({required Map contact}) {

    return Container(
      height: 190,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(
                Icons.home_repair_service,
                color: Colors.black,
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                contact['name'],
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(
                Icons.add_box,
                color: Colors.black,
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                contact['sid'],
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(
                Icons.phone_iphone,
                color: Colors.black,
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                'Expiry Date: ',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                contact['date'],
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(
                Icons.accessibility,
                color: Colors.black,
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                'Remarks: ',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                contact['remarks'],
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(
                Icons.qr_code,
                color: Colors.black,
                size: 20,
              ),
              SizedBox(
                height: 10,
              ),

              SizedBox(
                width: 6,
              ),
              Text(
                contact['id'],
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => details(
                            contactKey: contact['key'],
                          )));
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text('Edit',
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
            ],
          )
        ],
      ),



    );
  }
  getContactDetail() async {

    DataSnapshot snapshot = await _ref.child(widget.contactKey).once();

    Map contact = snapshot.value;

    setState(() {
      _nameController.text = contact['name'];
    });
    setState(() {
      _numberController.text = contact['sid'];
    });
    setState(() {
      _remarksController.text = contact['remarks'];
    });
    setState(() {
      _imgController = contact ['img'];
    });
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
