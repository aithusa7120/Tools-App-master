import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'storage.dart';






class testpage extends StatefulWidget {
  const testpage({Key? key}) : super(key: key);

  @override
  _testpageState createState() => _testpageState();

}

class _testpageState extends State<testpage> {

  @override

  Widget build(BuildContext context) {
    final Storage storage = Storage();
    return Container(


        child: ElevatedButton(onPressed: () async {
          final results = await FilePicker.platform.pickFiles(
            allowMultiple: false,
            type: FileType.custom,
            allowedExtensions: ['png','jpg'],

          );
          if (results == null){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No file selected'),
              ),
            );
            return null;
          }

          final path = results.files.single.path!;
          final fileName = results.files.single.name;

          storage.uploadFile(path, fileName).then((value)=> print('Done'));

        }, child: Text('Upload File')),

    );
  }

  }
