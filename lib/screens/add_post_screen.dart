import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_media_app/components/loading_spinner.dart';

import 'package:social_media_app/constants.dart';
import 'package:social_media_app/cubit/app_cubit.dart';
import 'package:social_media_app/cubit/app_states.dart';
import 'package:social_media_app/models/current_user.dart';

class AddPostScreen extends StatefulWidget {
  static const routeName = '/add-post-screen';

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String _postTextContent;
  TextEditingController _postTextContentController = TextEditingController()..text = 'Write what\'s in your mind!';
  ImageProvider<Object>? postImage;
  File? postImageFile;
  bool isPhotoExists = false;
  bool isFirstTap = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('Add Post'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 5),
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                          child: CircleAvatar(
                            radius: 25,
                            backgroundImage:
                            NetworkImage(CurrentUser.profileImageUrl),
                          ),
                        ),
                        SizedBox(width:10),
                        Text(CurrentUser.name.toString(),style: kText1,),
                      ],
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderSide: BorderSide.none),
                          labelText: 'Content',
                          labelStyle: TextStyle(fontSize: 25),
                          fillColor: Colors.grey[900],
                          contentPadding: EdgeInsets.only(top: 50,right: 5,left: 5)
                      ),
                      controller: _postTextContentController,
                      maxLines: 15,
                      onTap: (){ if(isFirstTap){isFirstTap=false; _postTextContentController.text='';}},
                      onSaved: (value) => _postTextContent = value!,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'please enter post Content.';
                        }
                        return null;
                      },
                    ),
                    isPhotoExists?
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          height: 140,
                          decoration: BoxDecoration(
                            image: DecorationImage(image: postImage!, fit: BoxFit.cover),
                          ),
                        ),
                        IconButton(
                          icon: Icon(FontAwesomeIcons.timesCircle),
                          onPressed: () => setState(() {
                            postImage = null;
                            postImageFile = null;
                            isPhotoExists = false;
                          }),
                        )
                      ],
                    )
                    : Container(height: 140),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(FontAwesomeIcons.camera),
                                Text('Add Photo',style: TextStyle(fontSize: 18),),
                              ],
                            ),
                            onPressed:() async {
                              await cubit.pickImageFromGallery()
                                  .then((imageFile) {
                                      postImageFile = imageFile;
                                      setState((){
                                        postImage = FileImage(imageFile);
                                        isPhotoExists = true;
                                      });
                                  }).catchError((error) {});
                            },
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(FontAwesomeIcons.eraser),
                                Text('Clear Text',style: TextStyle(fontSize: 18),),
                              ],
                            ),
                            onPressed: () => setState((){
                              _postTextContentController.text = '';
                            }),
                          ),
                        ),
                      ],
                    ),
                    state is AppPostingLoadingState
                    ? Center(child: CircularProgressIndicator())
                    : OutlinedButton(
                      child: Text('Post',style: TextStyle(fontSize: 20),),
                      onPressed: ()async {
                        if(_formKey.currentState!.validate()){
                          _formKey.currentState!.save();
                          LoadingSpinner(context);
                          await cubit.postUserPost(
                              postContentText: _postTextContent,
                              postImageFile: postImageFile,
                              context: context
                          ).then((value){Navigator.of(context).pop(); Navigator.of(context).pop();});
                        }
                       },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
