import 'package:flutter/material.dart';


import 'package:social_media_app/constants.dart';
import 'package:social_media_app/cubit/app_cubit.dart';

import 'package:social_media_app/screens/chatting_screen.dart';

class PickToChatScreen extends StatelessWidget {
  static const routeName = '/pick-to-chat-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick To Chat'),
        centerTitle: true,
      ),
      body: ListView.separated(
        itemCount: AppCubit.friendsList.length,
        itemBuilder: (_,i){
          return InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(AppCubit.friendsList[i].profileImageUrl),
                  ),
                  SizedBox(width:10),
                  Text(AppCubit.friendsList[i].name,style: kText1,),
                ],
              ),
            ),
            onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>ChattingScreen(AppCubit.friendsList[i]))),
          );
        },
        separatorBuilder: (_,i){
          return Divider(height: 20,thickness: 2,color: Colors.grey,);
        },
      ),
    );
  }
}
/*
            */
