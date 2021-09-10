import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/components/post.dart';
import 'package:social_media_app/components/toast.dart';
import 'package:social_media_app/constants.dart';
import 'package:social_media_app/cubit/app_cubit.dart';
import 'package:social_media_app/cubit/app_states.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/screens/chatting_screen.dart';



class UserScreen extends StatefulWidget {

  final UserModel user;
  UserScreen(this.user);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool isInit = true;
  List posts = [];

  @override
  void didChangeDependencies() {
    AppCubit.get(context).getUserPosts(context,widget.user.uid)
    .then((value){
      FirebaseFirestore.instance.collection('Users')
          .doc(widget.user.uid).collection('Posts').snapshots().listen((event){
            AppCubit.get(context).getUserPosts(context,widget.user.uid)
                .then((value) => setState(() { posts = value; }));
          });
    });
    super.didChangeDependencies();
  }


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
        return Scaffold(
            appBar: AppBar(
              title: Text(widget.user.name),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
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
                                    image: NetworkImage( widget.user.coverImageUrl ),
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
                                  backgroundImage: NetworkImage( widget.user.profileImageUrl ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Text(widget.user.name.toString(),style: kText1,textAlign: TextAlign.center,),
                      SizedBox(height: 8),
                      Text(widget.user.bio.toString(),style: kText2Grey,textAlign: TextAlign.center,),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(child: textColumn(text:'Posts', subText:widget.user.postCount.toString())),
                          SizedBox(width: 8),
                          Expanded(child: textColumn(text:'Friends', subText:widget.user.friendsCount.toString())),
                          SizedBox(width: 8),
                          Expanded(child: textColumn(text:'Shares', subText:widget.user.sharesCount.toString())),
                        ],
                      ),
                      SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                child: Text('Send Message',),
                                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder:(_)=> ChattingScreen(widget.user))),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton(
                                child: Text('Share',),
                                onPressed: ()async {
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return AlertDialog(
                                          title: Text(
                                            'Share your friend\'s Id with others so they can be friends them too.',
                                            style: kText1.copyWith(fontWeight: FontWeight.normal),
                                          ),
                                          titlePadding: EdgeInsets.only(top: 15,left: 15,right: 15,bottom: 5),
                                          actions: [
                                            Container(
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                child: Text('Copy Id',style: TextStyle(fontSize: 16),),
                                                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kBlueColor)),
                                                onPressed:()=> Clipboard.setData(ClipboardData(text:widget.user.uid))
                                                    .then((value) => Navigator.of(context).pop())
                                                    .then((value) => toast(context, 'User Id Copied', kBlueColor)),
                                              ),
                                            )
                                          ],
                                        );
                                      });
                                } ,
                              ),
                            ),
                          ]
                        ),
                      ),
                    ],
                  ) ,
                  posts.length == 0
                      ? Center(child: CircularProgressIndicator())
                      : posts[0].publisherName ==''
                      ? Text('\nThere is no Posts', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500), textAlign: TextAlign.center,)
                      : Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: posts.length,
                        itemBuilder: (_,i) => Post(posts[i],widget.user),
                      )
                  )
                ],
              ),
            )
        );
      },
    );
  }
}
