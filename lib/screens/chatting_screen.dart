import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:social_media_app/constants.dart';
import 'package:social_media_app/cubit/app_cubit.dart';
import 'package:social_media_app/cubit/app_states.dart';
import 'package:social_media_app/models/current_user.dart';
import 'package:social_media_app/models/message_model.dart';
import 'package:social_media_app/models/user_model.dart';

class ChattingScreen extends StatefulWidget {
  static const routeName = '/chatting-screen';

  final UserModel friend;

  ChattingScreen(this.friend);

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  bool isInit = true;

  List<MessageModel> chat = [];

  @override
  Widget build(BuildContext context) {
    TextEditingController messageController = TextEditingController();
    ScrollController scrollController = ScrollController();
    bool isWritingEnabled = true;

    AppCubit.get(context).getChat(chat,widget.friend.uid, scrollController,context).then((value){
       Future.delayed(Duration(milliseconds: 1000)).then((value){
         if (scrollController.hasClients) {
           scrollController.animateTo(
             scrollController.position.maxScrollExtent + 200,
             duration: Duration(milliseconds: 100),
             curve: Curves.easeInCirc
           );
         }
       });
    });


    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = AppCubit.get(context);

        return Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(radius: 22,
                      backgroundImage: NetworkImage(widget.friend.profileImageUrl)),
                  SizedBox(width: 10),
                  Text(widget.friend.name, style: kText1,),
                ],
              ),
              titleSpacing: 0,
              centerTitle: true,
              leading: IconButton(
                icon: Icon(FontAwesomeIcons.arrowLeft),
                onPressed: (){ Navigator.of(context).pop(); },
              ),
            ),
            body: Column(
              children: [
                chat.isEmpty
                 ? Expanded(child: Center(child: CircularProgressIndicator()))
                 : chat[0].senderId == ''
                    ? Expanded(child: Center(child: Text('send a message',style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),)))
                    : Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: EdgeInsets.all(8),
                    itemCount: chat.length,
                    itemBuilder: (_, i) {
                      return Align(
                          alignment: chat[i].senderId == CurrentUser.uid
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Padding(
                              padding: const EdgeInsets.only(left: 8,right: 8,bottom: 2,top: 2),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: chat[i].senderId == CurrentUser.uid? Colors.cyan.shade800 : Colors.teal.shade700,
                                    borderRadius: BorderRadius.only(
                                      topRight: chat[i].senderId == CurrentUser.uid? Radius.circular(0): Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      topLeft: chat[i].senderId == CurrentUser.uid? Radius.circular(10): Radius.circular(0),
                                    )
                                ),
                                padding: EdgeInsets.all(10),
                                child: Text(chat[i].message, style: kText2.copyWith(fontSize: 16),),
                              )
                          )
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5, left: 5, bottom: 8),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Theme.of(context).primaryColorDark,
                      hintText: 'write a message.....',
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      suffixIcon: TextButton(
                        child: Icon(isWritingEnabled? FontAwesomeIcons.solidPaperPlane : FontAwesomeIcons.hourglassHalf) ,
                        onPressed: isWritingEnabled? () async {
                          if (messageController.text.trim().isNotEmpty) {
                            setState((){ isWritingEnabled = false; });
                            String message = messageController.text.trim();
                            messageController.text = '';
                            await cubit.sendMessage(widget.friend.uid, message,context);
                            setState((){ isWritingEnabled = true; });
                          }
                        } : null,
                      ),
                    ),
                    controller: messageController,
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 3,
                  ),
                ),
              ],
            )
        );
      },
    );
  }
}