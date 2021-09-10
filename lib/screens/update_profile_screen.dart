import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_media_app/components/loading_spinner.dart';
import 'package:social_media_app/components/toast.dart';

import 'package:social_media_app/constants.dart';
import 'package:social_media_app/cubit/app_cubit.dart';
import 'package:social_media_app/cubit/app_states.dart';
import 'package:social_media_app/models/current_user.dart';

class UpdateProfileScreen extends StatefulWidget {
  static const routeName = '/update-profile-screen';
  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String _newName, _newBio ;

  TextEditingController _nameController = TextEditingController()..text = CurrentUser.name!;
  TextEditingController _bioController = TextEditingController()..text = CurrentUser.bio;

  ImageProvider<Object>? profileImage = NetworkImage(CurrentUser.profileImageUrl);
  ImageProvider<Object> coverImage = NetworkImage(CurrentUser.coverImageUrl);

  File? profileImageFile;
  File? coverImageFile;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state){
        final cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('Edit Profile'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    height: 260,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              height: 180,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: coverImage ,
                                    fit: BoxFit.cover
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(FontAwesomeIcons.camera),
                              onPressed: ()async
                              {
                                await cubit.pickImageFromGallery()
                                    .then((imageFile){
                                      coverImageFile = imageFile;
                                       setState(() => coverImage = FileImage(imageFile) );
                                    })
                                    .catchError((error){});
                              },
                            )
                          ],
                        ),
                        Positioned(
                          height: 260,
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 80,
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                child: CircleAvatar(
                                  radius: 75,
                                  backgroundImage:  profileImage ,
                                ),
                              ),
                              IconButton(
                                icon: Icon(FontAwesomeIcons.camera),
                                onPressed: () async
                                {
                                   await cubit.pickImageFromGallery()
                                    .then((imageFile){
                                      profileImageFile = imageFile;
                                      setState(() => profileImage = FileImage(imageFile) );
                                     })
                                    .catchError((error){});
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 25),
                        Row(
                          children: [
                            Text(
                              ' Copy your own Id : ',
                              style: kText1.copyWith(fontWeight: FontWeight.normal),
                            ),
                            Container(
                              child: OutlinedButton(
                                child: Text('Copy',),
                                style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
                                onPressed:()=> Clipboard.setData(ClipboardData(text:CurrentUser.uid))
                                    .then((value) => toast(context, 'Your Id Copied ', kBlueColor)),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Name',
                            filled: true,
                            labelStyle: TextStyle(fontSize: 20),
                            fillColor: Colors.grey[900],
                          ),
                          controller: _nameController,
                          textInputAction: TextInputAction.next,
                          onSaved: (value) { _newName = value!; },
                          validator: (value)
                          {
                            if (value!.trim().isEmpty) { return 'please enter a username.'; }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Bio',
                            filled: true,
                            labelStyle: TextStyle(fontSize: 20),
                            fillColor: Colors.grey[900],
                          ),
                          controller: _bioController,
                          maxLines: 4,
                          onSaved: (value) { _newBio = value!; },
                          validator: (value)
                          {
                            if (value!.trim().isEmpty) { return 'please enter a bio.'; }
                            return null;
                          },
                        ),
                        SizedBox(height: 35),
                        state is AppUpdateProfileLoadingState
                            || state is AppUploadImageLoadingState
                            || state is AppDownloadImageLoadingState
                            ?Center(child: CircularProgressIndicator())
                            :ElevatedButton(
                          child: Text('Save',style: TextStyle(fontSize: 20),),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(kBlueColor),
                              overlayColor: MaterialStateProperty.all(kRedColor),
                              padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 12))
                          ),
                          onPressed: () async {
                            if(_formKey.currentState!.validate()){
                              _formKey.currentState!.save();
                              LoadingSpinner(context);
                              await cubit.updateProfileData(
                                  newName: _newName,
                                  newBio: _newBio,
                                  profileImageFile: profileImageFile,
                                  coverImageFile: coverImageFile,
                                  context: context
                              )
                                  .then((value){Navigator.of(context).pop(); Navigator.of(context).pop();});
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}
