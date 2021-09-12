import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/components/toast.dart';
import 'package:social_media_app/cubit/app_states.dart';
import 'package:social_media_app/models/chat_model.dart';
import 'package:social_media_app/models/current_user.dart';
import 'package:social_media_app/models/message_model.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/screens/nav_screens/alerts_screen.dart';
import 'package:social_media_app/screens/nav_screens/chat_screen.dart';
import 'package:social_media_app/screens/nav_screens/home_screen.dart';
import 'package:social_media_app/screens/nav_screens/profile_screen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialState());

  static AppCubit get(BuildContext context) => BlocProvider.of(context);

  static User? user;

  static List<Widget> screensList = [ HomeScreen(), ChatScreen(), AlertsScreen(), ProfileScreen(),];

  static List<PostModel> userPostsList = [];

  static List<PostModel> homePostsList = [];

  static List<UserModel> friendsList = [];

  static List<ChatModel> chatsList = [];

  Future<void> getUserData(BuildContext context) async
  {
    emit(AppGetUserLoadingState());
    try
    {
      DocumentSnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance.collection('Users').doc(user!.uid).get();
      CurrentUser.fromJson(data.data());

      emit(AppGetUserSuccessState());
    }
    catch(error)
    {
      emit(AppGetUserErrorState());
      String message = error.toString().substring(error.toString().indexOf("]")+1).trim();
      toast(context,message);
    }
  }

  Future<dynamic> getUserPosts(BuildContext context,[String? userUid]) async
  {
    emit(AppGetUserPostsLoadingState());
    try
    {
      List<PostModel> list = [];
      await FirebaseFirestore.instance.collection('Users')
      .doc(userUid??user!.uid).collection('Posts').get()
      .then((snapShotMap){
        snapShotMap.docs.forEach((post) {
          list.add(PostModel.fromJson(post.data()));
        });
      });

      if(userUid == null)
      {
        if(list.isNotEmpty){
          list.sort((a, b) => DateTime.parse(a.postDateTime).compareTo(DateTime.parse(b.postDateTime)));
          userPostsList = list.reversed.toList();
        }
        else{ userPostsList =[PostModel(postId: '', publisherId: '', publisherName: '', publisherProfileImageUrl: '', postDateTime: '', postContentText: '', postContentImageUrl: '')]; }
      }
      else
      {
        if(list.isNotEmpty){
          list.sort((a, b) => DateTime.parse(a.postDateTime).compareTo(DateTime.parse(b.postDateTime)));
          return list.reversed.toList();
        }
        else{ return [PostModel(postId: '', publisherId: '', publisherName: '', publisherProfileImageUrl: '', postDateTime: '', postContentText: '', postContentImageUrl: '')]; }
      }

      emit(AppGetUserPostsSuccessState());
    }
    catch(error)
    {
      emit(AppGetUserPostsErrorState());
      String message = error.toString().substring(error.toString().indexOf("]")+1).trim();
      toast(context,message);
    }
  }

  Future<dynamic> getHomePosts(BuildContext context) async
  {
    emit(AppGetHomePostsLoadingState());
    try
    {
      List<PostModel> list = [];
      List<String> friendsIds = [];

      // add current user posts
      await FirebaseFirestore.instance.collection('Users')
          .doc(user!.uid).collection('Posts').get()
          .then((snapShotMap){
        snapShotMap.docs.forEach((post) {
          list.add(PostModel.fromJson(post.data()));
        });
      });

      // add friends posts
      await FirebaseFirestore.instance.collection('Users')
          .doc(CurrentUser.uid).collection('Friends').get().then((value){
        value.docs.forEach((friend){
          friendsIds.add(friend.data()['Friend']);
        });
      });

      if(friendsIds.isNotEmpty)
      {
        await FirebaseFirestore.instance.collection('Users').get().then((value)
        async {
          for(var element in value.docs)
          {
            if(friendsIds.contains(element.id))
            {
              await FirebaseFirestore.instance.collection('Users')
              .doc(element.id).collection('Posts').get().then((snapShotMap) =>
                snapShotMap.docs.forEach((post) { list.add(PostModel.fromJson(post.data())); }) );
            }
          }
        });
      }

      if(list.isNotEmpty)
      {
        list.sort((a, b) => DateTime.parse(a.postDateTime).compareTo(DateTime.parse(b.postDateTime)));
        homePostsList = list.reversed.toList();
      }
      else{ homePostsList =[PostModel(postId: '', publisherId: '', publisherName: '', publisherProfileImageUrl: '', postDateTime: '', postContentText: '', postContentImageUrl: '')]; }

      emit(AppGetHomePostsSuccessState());
    }
    catch(error)
    {
      emit(AppGetHomePostsErrorState());
      String message = error.toString().substring(error.toString().indexOf("]")+1).trim();
      toast(context,message);
    }
  }

  Future<void> assignUser(BuildContext context) async
  {
    emit(AppAssignUserLoadingState());
    try
    {
      await FirebaseAuth.instance.currentUser!.reload()
          .then((value){ AppCubit.user = FirebaseAuth.instance.currentUser; });

      emit(AppAssignUserSuccessState());
    }
    catch(error)
    {
      emit(AppAssignUserErrorState());
      String message = error.toString().substring(error.toString().indexOf("]")+1).trim();
      toast(context,message);
    }
  }

  Future<void> _uploadUserImage(File imageFile, BuildContext context) async
  {
    emit(AppUploadImageLoadingState());
    try
    {
      await firebase_storage.FirebaseStorage.instance
          .ref().child('Users').child('${user!.uid}').child('Images')
          .child('${Uri.file(imageFile.path).pathSegments.last}').putFile(imageFile);

      emit(AppUploadImageSuccessState());
    }
    catch(error)
    {
      emit(AppUploadImageErrorState());
      String message = error.toString().substring(error.toString().indexOf("]")+1).trim();
      toast(context,message);
    }
  }

  Future<String?> _downloadUserImage(File imageFile, BuildContext context) async
  {
    emit(AppDownloadImageLoadingState());
    try
    {
      return await firebase_storage.FirebaseStorage.instance
          .ref().child('Users').child('${user!.uid}').child('Images')
          .child('${Uri.file(imageFile.path).pathSegments.last}')
          .getDownloadURL();
      emit(AppDownloadImageSuccessState());
    }
    catch(error)
    {
      emit(AppDownloadImageErrorState());
      String message = error.toString().substring(error.toString().indexOf("]")+1).trim();
      toast(context,message);
    }
  }

  Future<void> updateProfileData({
    required String newName,
    required String newBio,
    required File? profileImageFile,
    required File? coverImageFile,
    required BuildContext context
  }) async
  {
    emit(AppUpdateProfileLoadingState());
    try
    {
      String? profileImageUrl, coverImageUrl;

      if( profileImageFile != null  )
      {
        await _uploadUserImage(profileImageFile, context);
        profileImageUrl = await _downloadUserImage(profileImageFile, context);
      }
      if( coverImageFile != null  )
      {
        await _uploadUserImage(coverImageFile, context);
        coverImageUrl = await _downloadUserImage(coverImageFile, context);
      }

      await FirebaseFirestore.instance.collection('Users').doc(user!.uid)
          .update({
            'name': newName,
            'bio': newBio,
            'profileImageUrl': profileImageUrl?? CurrentUser.profileImageUrl,
            'coverImageUrl': coverImageUrl?? CurrentUser.coverImageUrl,
          });

      DocumentSnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance.collection('Users').doc(user!.uid).get();
      CurrentUser.fromJson(data.data());

      emit(AppUpdateProfileSuccessState());
    }
    catch(error)
    {
      emit(AppUpdateProfileErrorState());
      String message = error.toString().substring(error.toString().indexOf("]")+1).trim();
      toast(context,message);
    }
  }

  Future<File> pickImageFromGallery()async
  {
    XFile? imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if( imageFile != null ) { return File(imageFile.path); }
    else { throw 'no image is selected'; }
  }

  String _formattedDateTimeString()
  {
    String unformattedDateTime = DateTime.utc(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      DateTime.now().hour,
      DateTime.now().minute,
      DateTime.now().second,
    ).toString();
    String formattedDateTime = unformattedDateTime.substring(0,unformattedDateTime.lastIndexOf(':')+3);
    return formattedDateTime;
  }

  Future<void> postUserPost({
    required String postContentText,
    required File? postImageFile,
    required BuildContext context
   }) async
  {
    emit(AppPostingLoadingState());
    try
    {
      String? postImageUrl;
      if( postImageFile != null  )
      {
        await _uploadUserImage(postImageFile, context);
        postImageUrl = await _downloadUserImage(postImageFile, context);
      }

      PostModel post = PostModel(
          postId: CurrentUser.postCount.toString(),
          publisherId: CurrentUser.uid!,
          publisherName: CurrentUser.name.toString(),
          publisherProfileImageUrl: CurrentUser.profileImageUrl.toString(),
          postDateTime: _formattedDateTimeString(),
          postContentText: postContentText,
          postContentImageUrl: postImageUrl,
      );

      await FirebaseFirestore.instance.collection('Users').doc(CurrentUser.uid)
          .collection('Posts').doc(CurrentUser.postCount.toString())
          .set(post.toMap());


      await FirebaseFirestore.instance.collection('Users').doc(user!.uid)
          .update({'postCount': (CurrentUser.postCount+1),});

      emit(AppPostingSuccessState());
    }
    catch(error)
    {
      emit(AppPostingErrorState());
      String message = error.toString().substring(error.toString().indexOf("]")+1).trim();
      toast(context,message);
    }
  }

  Future<void> _updatePosts(BuildContext context) async
  {
    await getHomePosts(context);
    await getUserPosts(context);
  }

  Future<void> toggleLike(String publisherId, String postId, bool isLiked, BuildContext context) async
  {
    emit(AppPostLikeLoadingState());
    try
    {
      late int numLikes;
      List likersIdsList = [];
      await FirebaseFirestore.instance.collection('Users')
          .doc(publisherId).collection('Posts').doc(postId)
          .get().then((value){
            numLikes = value.data()!['postLikesCount'];
            likersIdsList = value.data()!['likersIds'];
          });

      if(isLiked){ numLikes++; likersIdsList.add(AppCubit.user!.uid); }
      else { numLikes--; likersIdsList.remove(AppCubit.user!.uid); }

      await FirebaseFirestore.instance.collection('Users')
          .doc(publisherId).collection('Posts').doc(postId)
      .update({
        'postLikesCount' : numLikes,
        'likersIds' : likersIdsList
      });

      await _updatePosts(context);

      emit(AppPostLikeSuccessState());
    }
    catch(error)
    {
      emit(AppPostLikeErrorState());
      String message = error.toString().substring(error.toString().indexOf("]")+1).trim();
      toast(context,message);
      throw 'operation failed';
    }
  }

  Future<void> postComment({
    required String publisherId,
    required String postId,
    required String commentingUserId,
    required String commentingUserName,
    required String commentingUserImageUrl,
    required String comment,
    required BuildContext context
  }) async
  {
    emit(AppPostingCommentLoadingState());
    try
    {
      late int numComments;
      List commentList = [];

      await FirebaseFirestore.instance.collection('Users')
          .doc(publisherId).collection('Posts').doc(postId)
          .get().then((value){
        numComments = value.data()!['postCommentsCount'];
        commentList = value.data()!['postComments'];
      });

      numComments++;
      commentList.insert(0,
      {
        'commentingUserId': commentingUserId,
        'commentingUserName': commentingUserName,
        'commentingUserImageUrl': commentingUserImageUrl,
        'comment': comment,
        'DateTime' : _formattedDateTimeString()
      });

      await FirebaseFirestore.instance.collection('Users')
          .doc(publisherId).collection('Posts').doc(postId)
          .update({
        'postCommentsCount' : numComments,
        'postComments' : commentList
      });

      emit(AppPostingCommentSuccessState());

      await _updatePosts(context);
    }
    catch(error)
    {
      emit(AppPostingCommentErrorState());
      String message = error.toString().substring(error.toString().indexOf("]")+1).trim();
      toast(context,message);
    }
  }

  Future<void> getFriends(BuildContext context) async
  {
    emit(AppGetFriendsLoadingState());
    try
    {
      List<String> friendsIds = [];
      List<UserModel> list = [];


      await FirebaseFirestore.instance.collection('Users')
        .doc(CurrentUser.uid).collection('Friends').get().then((value){
          value.docs.forEach((friend){
            friendsIds.add(friend.data()['Friend']);
          });
      });

      await FirebaseFirestore.instance.collection('Users').get()
      .then((value){
        value.docs.forEach((element){
          if(friendsIds.contains(element.id)){
            list.add(UserModel.fromJson(element.data()));
          }
        });
      });

      friendsList = list;

      emit(AppGetFriendsSuccessState());
    }
    catch(error)
    {
      emit(AppGetFriendsErrorState());
      String message = error.toString().substring(error.toString().indexOf("]")+1).trim();
      toast(context,message);
    }
  }

  Future<void> addFriend(String friendId, BuildContext context) async
  {
    emit(AppAddFriendLoadingState());
    try
    {
      bool isFound = false;

      await FirebaseFirestore.instance.collection('Users').get()
          .then((value) => value.docs.forEach((element){ if(element.id == friendId){ isFound = true;} }));
      await FirebaseFirestore.instance.collection('Users').doc(CurrentUser.uid).collection('Friends').get()
          .then((value) => value.docs.forEach((element){ if(element.data()['Friend'] == friendId){ isFound = false; throw 'You\'re already friend with him';} }));

      if(isFound)
      {
        await FirebaseFirestore.instance.collection('Users').doc(CurrentUser.uid)
            .collection('Friends').doc(AppCubit.friendsList.length.toString())
            .set({'Friend': friendId });

        await FirebaseFirestore.instance.collection('Users').doc(CurrentUser.uid)
            .update({'friendsCount':(AppCubit.friendsList.length)});

        // friend(the other user) update
        FirebaseFirestore.instance.collection('Users').doc(friendId).get().then((value)
        {
          int friendCount = value.data()!['friendsCount'];

          FirebaseFirestore.instance.collection('Users').doc(friendId)
              .collection('Friends').doc(friendCount.toString())
              .set({'Friend': CurrentUser.uid });

          FirebaseFirestore.instance.collection('Users').doc(friendId)
              .update({'friendsCount': (friendCount+1) });
        });
      }
      else{ throw 'Wrong Id';}

      emit(AppAddFriendSuccessState());
    }
    catch(error)
    {
      emit(AppAddFriendErrorState());
      String message = error.toString().substring(error.toString().indexOf("]")+1).trim();
      toast(context,message);
    }
  }

  Future<void> getChats(BuildContext context) async
  {
    emit(AppGetAllChatsLoadingState());
    try
    {
      FirebaseFirestore.instance.collection('Users')
      .doc(CurrentUser.uid).collection('Chats').snapshots()
      .listen((event) {
        if(event.docs.isEmpty)
        {
          chatsList=[ChatModel(UserModel.fromJson({
                'uid': '',
                'email': '',
                'name': '',
                'bio':'' ,
                'profileImageUrl': '',
                'coverImageUrl': '',
                'postCount': 0,
                'friendsCount':0 ,
                'sharesCount': 0,
              }))];
        }
        else
        {
          chatsList.clear();
          for(var element in event.docs)
          {
            chatsList.add(ChatModel(friendsList.firstWhere((friend) => friend.uid == element.id)));
          }
        }
        emit(AppGetAllChatsSuccessState());
      });

    }
    catch(error)
    {
      emit(AppGetAllChatsErrorState());
      String message = error.toString().substring(error.toString().indexOf("]")+1).trim();
      toast(context,message);
    }
  }

  Future<void> getChat(List chat, String friendId, ScrollController sc,BuildContext context) async
  {
    emit(AppGetChatLoadingState());
    try
    {
      FirebaseFirestore.instance.collection('Users')
      .doc(CurrentUser.uid).collection('Chats').doc(friendId)
      .collection('Messages').orderBy('DateTime').snapshots()
      .listen((event){
        if(event.docs.isEmpty){ chat.clear(); chat.add(MessageModel()); }
        else
        {
          chat.clear();
          event.docs.forEach((element) {
            chat.add(MessageModel.fromJson(element.data()));
          });
        }
        emit(AppGetChatSuccessState());
        Future.delayed(Duration(milliseconds:0)).then((value){
          if (sc.hasClients)
          {
            sc.animateTo(
                sc.position.maxScrollExtent + 1000,
                duration: Duration(milliseconds: 10),
                curve: Curves.easeInCirc
            );
          }
        });
        emit(AppGetChatSuccessState());

      });


    }
    catch(error)
    {
      emit(AppGetChatErrorState());
      String message = error.toString().substring(error.toString().indexOf("]")+1).trim();
      toast(context,message);
    }
  }

  Future<void> sendMessage(String friendId, String message, BuildContext context) async
  {
    emit(AppSendMessageLoadingState());
    try
    {
      String dateTime = _formattedDateTimeString();
      late int messageCount;
      await FirebaseFirestore.instance.collection('Users').doc(CurrentUser.uid)
          .collection('Chats').doc(friendId).get().then((value) {
        if(value.data()?['messageCount'] != null ){messageCount = ((value.data()?['messageCount'])-1);}
        else{ messageCount = -1; }
      });

      await FirebaseFirestore.instance.collection('Users').doc(CurrentUser.uid)
      .collection('Chats').doc(friendId).collection('Messages').doc((messageCount+1).toString())
      .set({
        'DateTime': dateTime,
        'senderId': CurrentUser.uid,
        'receiverId':friendId,
        'message': message
      });

      FirebaseFirestore.instance.collection('Users').doc(friendId)
          .collection('Chats').doc(CurrentUser.uid).collection('Messages').doc((messageCount+1).toString())
          .set({
        'DateTime': dateTime,
        'senderId': CurrentUser.uid,
        'receiverId': friendId,
        'message': message
      });

      if(messageCount == -1)
      {
        await FirebaseFirestore.instance.collection('Users').doc(CurrentUser.uid)
            .collection('Chats').doc(friendId).set({'messageCount': (messageCount+2)});

        FirebaseFirestore.instance.collection('Users').doc(friendId)
            .collection('Chats').doc(CurrentUser.uid).set({'messageCount': (messageCount+2)});
      }
      else
      {
        await FirebaseFirestore.instance.collection('Users').doc(CurrentUser.uid)
            .collection('Chats').doc(friendId).update({'messageCount': (messageCount+2)});

        FirebaseFirestore.instance.collection('Users').doc(friendId)
            .collection('Chats').doc(CurrentUser.uid).update({'messageCount': (messageCount+2)});
      }


      emit(AppSendMessageSuccessState());
    }
    catch(error)
    {
      emit(AppSendMessageErrorState());
      String message = error.toString().substring(error.toString().indexOf("]")+1).trim();
      toast(context,message);
    }
  }

}