import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:social_media_app/cubit/app_cubit.dart';
import 'package:social_media_app/models/current_user.dart';

class Test extends StatefulWidget {

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Testing'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('test'),
              onPressed: () async {


                await FirebaseFirestore.instance.collection('Users').get()
                    .then((value){
                  value.docs.forEach((element) { print(element.id); });
                });



              }
            ),
          ],
        ),
      ),
    );
  }
}

