import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:social_media_app/constants.dart';
import 'package:social_media_app/cubit/app_cubit.dart';
import 'package:social_media_app/models/current_user.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/models/user_model.dart';

class Post extends StatefulWidget {

  late final PostModel post;
  final UserModel? user;

  Post(this.post,this.user);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  bool isLiked = false;
  bool isLikeBtnEnabled = true;

  Future<void> openBottomSheet(BuildContext context,PostModel post) async
  {
    TextEditingController commentController = TextEditingController();

    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))),
        builder: (context) => Container(
          height: MediaQuery.of(context).size.height*0.92,
          padding: EdgeInsets.only(top: 10.0,left: 8,right: 8,bottom: 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(radius: 20, backgroundImage: NetworkImage(CurrentUser.profileImageUrl)),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25),),
                        hintText: 'write a comment...',
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        suffixIcon: TextButton(
                          child: Text('Post'),
                          onPressed: () async {
                            if (commentController.text.trim().isEmpty)
                            {
                              showDialog(context: context, builder: (_)=> Center(child: Text('enter a comment to post.'),));
                            }
                            else
                            {
                              showDialog(context: context, builder: (_)=> Center(child: Text('Please Wait\nPosting Comment...',textAlign: TextAlign.center,),));
                              await AppCubit.get(context).postComment(
                                  publisherId: post.publisherId,
                                  postId: post.postId,
                                  commentingUserId: CurrentUser.uid.toString(),
                                  commentingUserName: CurrentUser.name.toString(),
                                  commentingUserImageUrl: CurrentUser.profileImageUrl,
                                  comment: commentController.text.trim(),
                                  context: context
                              )
                              .then((value) {
                                AppCubit.get(context).getHomePosts(context)
                                .then((value){
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  openBottomSheet(context, widget.post);
                                });
                              })
                              .catchError((e){ Navigator.of(context).pop();Navigator.of(context).pop(); openBottomSheet(context, widget.post); });
                            }
                          },
                        ),
                      ),
                      controller: commentController,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              Divider(height: 25, thickness: 1,),
              post.postComments.isEmpty
                  ? Text('No Comments',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),)
                  : Expanded(
                child: ListView.separated(
                  itemCount: post.postComments.length,
                  itemBuilder: (_,i)=> Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(radius: 18, backgroundImage: NetworkImage(post.postComments[i]['commentingUserImageUrl'])),
                      Expanded(
                        child: Card(
                          margin: EdgeInsets.only(top: 0,left: 5,right: 5),
                          color: Theme.of(context).primaryColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(width:150,child: Text(post.postComments[i]['commentingUserName'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,height: 0.8),overflow: TextOverflow.ellipsis,)),
                                    SizedBox(width: 10),
                                    Text(post.postComments[i]['DateTime'],style: TextStyle(fontSize: 12,height: 0.8,color: Colors.grey[400]),),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Text(post.postComments[i]['comment']),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  separatorBuilder: (_,i)=>SizedBox(height: 10),
                ),
              ),
            ],
          ),
        ),

    );
  }

  @override
  void initState() {
    isLiked = widget.post.likersIds.contains(CurrentUser.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      color: Color(0xFF151517),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(width: 1.8,color: Colors.grey.shade900,),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(widget.user==null?CurrentUser.profileImageUrl:widget.user!.profileImageUrl),
                  ),
                  SizedBox(width:10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.post.publisherName,style: kText1,),
                      Text(widget.post.postDateTime,style: TextStyle(height: 1.35,color: Colors.grey[400]),),
                    ],
                  ),
                  Spacer(),
                  //IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.caretDown,size: 22,),splashRadius: 18,)
                ],
              ),
              Divider(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2,vertical: 5),
                child: Text(
                  widget.post.postContentText,
                  style: kText2,
                ),
              ),
              SizedBox(height: 5),

              widget.post.postContentImageUrl == null
              ? Container()
              : Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Card(
                  margin: EdgeInsets.zero,
                  clipBehavior: Clip.antiAlias,
                  elevation: 0,
                  child: Image.network(
                    widget.post.postContentImageUrl!,
                  ),
                ),
              ),

              Container(
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon( isLiked? FontAwesomeIcons.solidHeart :FontAwesomeIcons.heart,size: 22,),
                      constraints: BoxConstraints.expand(height: 30,width: 30),
                      color: kRedColor,
                      splashColor:  Colors.teal[900],
                      highlightColor:  Colors.grey.withOpacity(0.5),
                      splashRadius: 18,
                      onPressed: isLikeBtnEnabled ? () async {
                        isLikeBtnEnabled = false;
                        setState(()=>isLiked = !isLiked);
                        await AppCubit.get(context).toggleLike(widget.post.publisherId, widget.post.postId ,isLiked,context)
                        .catchError((e){ setState(()=>isLiked = !isLiked);  })
                        .then((value) => isLikeBtnEnabled = true);
                      } : (){},
                    ),
                    SizedBox(width: 5),
                    Text(widget.post.postLikesCount.toString()),
                    Spacer(),
                    IconButton(
                      constraints: BoxConstraints.expand(height: 30,width: 30),
                      padding: EdgeInsets.zero,onPressed: (){ openBottomSheet(context,widget.post); },
                      icon: Icon(FontAwesomeIcons.comments,size: 22,),
                      color: kBlueColor,
                      splashColor:  Colors.teal[900],
                      highlightColor:  Colors.grey.withOpacity(0.5),
                      splashRadius: 18,
                    ),
                    SizedBox(width: 5),
                    Text(widget.post.postCommentsCount.toString()),
                  ],
                ),
              ),
              Divider(height: 20),
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(CurrentUser.profileImageUrl)
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text('write a comment....   '),
                    ),
                    splashColor: Colors.teal[900],
                    onTap: () {
                      openBottomSheet(context, widget.post);
                    },
                  ),
                ],
              ),
            ]
        ),
      ),
    );
  }
}
