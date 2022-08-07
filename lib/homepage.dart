import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:toolapp/test.dart';
import 'package:toolapp/test2.dart';

class Contacts extends StatefulWidget {
  const Contacts({Key? key}) : super(key: key);

  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  late Query _ref;
  DatabaseReference reference =
  FirebaseDatabase.instance.reference().child('tools');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ref = FirebaseDatabase.instance
        .reference()
        .child('tools')
        .orderByChild('date');
  }

  Widget _buildContactItem({required Map contact}) {

    return Container(


      height: 160,
        color: Colors.black12,
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
                color: Colors.white,
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                contact['name'],
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
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
                color: Colors.white,
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                'Expiry Date: ',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),


              Text(

                contact['date'],
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
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
                color: Colors.white,
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
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
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
                color: Colors.white,
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                'Remarks: ',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),


              Text(

                contact['remarks'],
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
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
                          builder: (_) => EditContact(
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
              GestureDetector(
                onTap: () {
                  _showDeleteDialog(contact: contact);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.red[700],
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text('Delete',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.red[700],
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

  _showDeleteDialog({required Map contact}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete ${contact['name']}'),
            content: Text('Are you sure you want to delete?'),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              FlatButton(
                  onPressed: () {
                    reference
                        .child(contact['key'])
                        .remove()
                        .whenComplete(() => Navigator.pop(context));
                  },
                  child: Text('Delete'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        color: Colors.black87,
        height: double.infinity,
        child: FirebaseAnimatedList(
          query: _ref,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map contact = snapshot.value;
            contact['key'] = snapshot.key;
            return _buildContactItem(contact: contact);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) {
              return AddContacts();
            }),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}