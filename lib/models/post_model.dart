class PostModel
{
  late final String postId;
  late final String publisherId;
  late final String publisherName;
  late final String publisherProfileImageUrl;
  late final String postDateTime;
  late final String postContentText;
  late final String? postContentImageUrl;
  int postLikesCount = 0;
  int postCommentsCount = 0;
  List postComments = [];
  List likersIds = [];

  PostModel({
    required this.postId,
    required this.publisherId,
    required this.publisherName,
    required this.publisherProfileImageUrl,
    required this.postDateTime,
    required this.postContentText,
    required this.postContentImageUrl,
  });

  PostModel.fromJson(Map<String, dynamic> data) {
     postId = data['postId'];
     publisherId = data['publisherId'];
     publisherName = data['publisherName'];
     publisherProfileImageUrl = data['publisherProfileImageUrl'];
     postDateTime = data['postDateTime'];
     postContentText = data['postContentText'];
     postContentImageUrl= data['postContentImageUrl'];
     postLikesCount = data['postLikesCount'];
     postCommentsCount = data['postCommentsCount'];
     postComments = data['postComments'];
     likersIds = data['likersIds'];
  }

  Map<String, dynamic> toMap() => {
    'postId' : postId,
    'publisherId' : publisherId,
    'publisherName' : publisherName,
    'publisherProfileImageUrl' : publisherProfileImageUrl,
    'postDateTime' : postDateTime,
    'postContentText' : postContentText,
    'postContentImageUrl': postContentImageUrl,
    'postLikesCount' : postLikesCount,
    'postCommentsCount' : postCommentsCount,
    'postComments' : postComments,
    'likersIds' : likersIds
  };


}