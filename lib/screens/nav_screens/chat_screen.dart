import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:social_media_app/constants.dart';


import 'package:social_media_app/cubit/app_cubit.dart';
import 'package:social_media_app/cubit/app_states.dart';
import 'package:social_media_app/screens/chatting_screen.dart';
import 'package:social_media_app/screens/pick_to_chat_screen.dart';

class ChatScreen extends StatelessWidget {
  static const routeName = '/chat-screen';

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
          cubit.getFriends(context)
          .then((value) => cubit.getChats(context));
        }

        Widget noChatsScreen()
        {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(FontAwesomeIcons.solidPaperPlane, size: 50),
                SizedBox(height: 20),
                Text(
                  'There is no chats',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 25 ),
                InkWell(
                  child: Text(
                    'start chats with your friends',
                    style: TextStyle(
                        color: Colors.lightBlueAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.normal),
                    textAlign: TextAlign.center,
                  ),
                  onTap: ()=>Navigator.of(context).pushNamed(PickToChatScreen.routeName),
                ),
              ],
            ),
          );
        }

        return AppCubit.chatsList.isEmpty
        ? Center(child: CircularProgressIndicator())
        : AppCubit.chatsList[0].friend.uid == ''
          ? noChatsScreen()
          :GridView.count(
            padding: EdgeInsets.all(2),
            crossAxisCount: 2,
            childAspectRatio: 1/1.3,
            children: List.generate(AppCubit.chatsList.length, (i) => InkWell(
              child: Card(
                color: Colors.blueGrey.shade900,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(radius: 60, backgroundImage: NetworkImage(AppCubit.chatsList[i].friend.profileImageUrl),),
                      Text(AppCubit.chatsList[i].friend.name,style: kText1,textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,maxLines: 2,),
                    ],
                  ),
                ),
              ),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder:(_)=> ChattingScreen(AppCubit.chatsList[i].friend))),
            ),),
          );
      },
    );
  }
}