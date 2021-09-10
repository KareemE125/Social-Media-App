import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_media_app/components/loading_spinner.dart';

import 'package:social_media_app/constants.dart';


import 'package:social_media_app/cubit/app_cubit.dart';
import 'package:social_media_app/cubit/app_states.dart';
import 'package:social_media_app/models/current_user.dart';
import 'package:social_media_app/screens/user_screen.dart';

class FriendsScreen extends StatelessWidget {
  static const routeName = '/friends-screen';

  bool isInit = true;
  TextEditingController _friendIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = AppCubit.get(context);
        if (isInit)
        {
          isInit = false;
          cubit.getFriends(context).then((_){
             FirebaseFirestore.instance.collection('Users').doc(CurrentUser.uid)
                .collection('Friends').snapshots().listen((event)=> cubit.getFriends(context));
          });
        }

        print(AppCubit.friendsList.toString());
        Widget noFriendsScreen()
        {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(FontAwesomeIcons.userAltSlash, size: 50),
                SizedBox(height: 20),
                Text(
                  'There is no Friends',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Friends'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(FontAwesomeIcons.userPlus,size: 20,),
                onPressed: ()async {
                  _friendIdController.text = '';
                  showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          titlePadding: EdgeInsets.all(15),
                          title: Text(
                            'Put the Id',
                            style: kText1.copyWith(fontWeight: FontWeight.normal,),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          content:  TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'fgkskelLow0km2siwi82kdksmoslslW2',
                            ),
                            controller: _friendIdController,
                            maxLines: 1,
                          ),
                          actions: [
                            Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                child: Text('Add Friend',style: TextStyle(fontSize: 16),),
                                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kBlueColor)),
                                onPressed:() async {
                                  if(_friendIdController.text.trim().isNotEmpty)
                                  {
                                    LoadingSpinner(context);
                                    await cubit.addFriend(_friendIdController.text.trim(), context)
                                    .then((value){Navigator.of(context).pop(); Navigator.of(context).pop();});
                                  }
                                },
                              ),
                            )
                          ],
                        );
                      });
                } ,
              )
            ],
          ),
          body: state is AppGetFriendsLoadingState
              ? Center(child: CircularProgressIndicator())
              : AppCubit.friendsList.isEmpty
              ? noFriendsScreen()
              : ListView.builder(
            itemCount: AppCubit.friendsList.length,
            itemBuilder: (context,i){
              return InkWell(
                child: Card(
                  color: Colors.blueGrey.shade900,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(radius: 40, backgroundImage: NetworkImage(AppCubit.friendsList[i].profileImageUrl),),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${AppCubit.friendsList[i].name}',style: kText1,textAlign: TextAlign.left,overflow: TextOverflow.ellipsis,maxLines: 1,),
                              SizedBox(height: 10),
                              Text('Posts : ${AppCubit.friendsList[i].postCount}',style: kText2,textAlign: TextAlign.left,overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        )
                        ],
                    ),
                  ),
                ),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder:(_)=> UserScreen(AppCubit.friendsList[i]))),
              );

            },
          ),
        );
      },
    );
  }
}