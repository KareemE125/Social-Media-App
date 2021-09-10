import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/components/post.dart';


import 'package:social_media_app/cubit/app_cubit.dart';
import 'package:social_media_app/cubit/app_states.dart';
import 'package:social_media_app/models/current_user.dart';


class HomeScreen extends StatelessWidget {
  static const routeName = '/home-screen';

  bool isInit = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = AppCubit.get(context);
        if (isInit)
        {
          isInit = false;
          cubit.getUserData(context);
          cubit.getFriends(context);
          FirebaseFirestore.instance.collection('Users').doc(AppCubit.user!.uid)
              .collection('Posts').snapshots().listen((event){ print('------------++++++++++++++++++'); cubit.getHomePosts(context); });
        }

        return AppCubit.homePostsList.length == 0
        ? Center(child: CircularProgressIndicator())
        : AppCubit.homePostsList[0].publisherName == ''
         ? Center( child: Text('There is no Posts', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),),)
         : Padding(
            padding: const EdgeInsets.all(5.0),
            child: ListView.builder(
              itemCount: AppCubit.homePostsList.length,
              itemBuilder: (_,i) => Post(
                  AppCubit.homePostsList[i],
                  AppCubit.homePostsList[i].publisherId == CurrentUser.uid
                      ? null
                      : AppCubit.friendsList.firstWhere((friend) => AppCubit.homePostsList[i].publisherId == friend.uid)
              ),
            )
           );
      },
    );
  }
}