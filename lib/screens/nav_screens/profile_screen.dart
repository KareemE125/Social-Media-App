import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/components/post.dart';
import 'package:social_media_app/constants.dart';


import 'package:social_media_app/cubit/app_cubit.dart';
import 'package:social_media_app/cubit/app_states.dart';
import 'package:social_media_app/models/current_user.dart';
import 'package:social_media_app/screens/add_post_screen.dart';
import 'package:social_media_app/screens/friends_screen.dart';
import 'package:social_media_app/screens/update_profile_screen.dart';


class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile-screen';

  bool isInit = true;

  Widget textColumn({required String text, required String subText}){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(text, style: TextStyle(fontSize: 16,),),
        Text(subText, style: TextStyle(height: 1.3,fontSize: 16,),), ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = AppCubit.get(context);
        if (isInit) {
          isInit = false;
          cubit.getFriends(context);
          cubit.getUserData(context)
          .then((value){
              FirebaseFirestore.instance.collection('Users')
               .doc(AppCubit.user!.uid).collection('Posts').snapshots().listen((event){ cubit.getUserPosts(context); });
          });
        }

        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
             Column(
               crossAxisAlignment: CrossAxisAlignment.stretch,
               children: [
                 Container(
                   height: 270,
                   child: Stack(
                     alignment: Alignment.topCenter,
                     children: [
                       Container(
                         height: 180,
                         decoration: BoxDecoration(
                           image: DecorationImage(
                               image: NetworkImage( CurrentUser.coverImageUrl ),
                               fit: BoxFit.cover
                           ),
                         ),
                       ),
                       Positioned(
                         height: 360,
                         child:  CircleAvatar(
                           radius: 80,
                           backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                           child: CircleAvatar(
                             radius: 75,
                             backgroundImage: NetworkImage( CurrentUser.profileImageUrl ),
                           ),
                         ),
                       )
                     ],
                   ),
                 ),
                 Text(CurrentUser.name.toString(),style: kText1,textAlign: TextAlign.center,),
                 SizedBox(height: 8),
                 Text(CurrentUser.bio.toString(),style: kText2Grey,textAlign: TextAlign.center,),
                 SizedBox(height: 20),
                 Row(
                   children: [
                     Expanded(child: textColumn(text:'Posts', subText:CurrentUser.postCount.toString())),
                     SizedBox(width: 8),
                     Expanded(child: InkWell(
                       child: textColumn(text:'Friends', subText:CurrentUser.friendsCount.toString()),
                       onTap: () => Navigator.of(context).pushNamed(FriendsScreen.routeName),
                     ),),
                     SizedBox(width: 8),
                     Expanded(child: textColumn(text:'Shares', subText:CurrentUser.sharesCount.toString())),
                   ],
                 ),
                 SizedBox(height: 12),
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Row(
                     children: [
                       Expanded(
                         child: OutlinedButton(
                           child: Text('Add Post',),
                           onPressed: ()=>Navigator.of(context).pushNamed(AddPostScreen.routeName),
                         ),
                       ),
                       SizedBox(width: 8),
                       Expanded(
                         child: OutlinedButton(
                           child: Text('Edit Profile'),
                           onPressed: () => Navigator.of(context).pushNamed(UpdateProfileScreen.routeName),
                         ),
                       ),
                     ],
                   ),
                 ),
               ],
             ),
              AppCubit.userPostsList.length == 0
                  ? Center(child: CircularProgressIndicator())
                  : AppCubit.userPostsList[0].publisherName ==''
                  ? Text('\nThere is no Posts', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500), textAlign: TextAlign.center,)
                  : Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: AppCubit.userPostsList.length,
                    itemBuilder: (_,i) => Post(AppCubit.userPostsList[i],null),
                  ),
              ),
            ],
          ),
        );
      },
    );
  }
}
