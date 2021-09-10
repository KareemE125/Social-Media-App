class UserModel {
  late String uid;
  late String email;
  late String name;
  late String bio;
  late String profileImageUrl;
  late String coverImageUrl ;
  late int postCount;
  late int friendsCount;
  late int sharesCount;


  UserModel.fromJson(Map<String, dynamic>? data) {
    uid = data!['uid'];
    email = data['email'];
    name = data['name'];
    bio = data['bio'];
    profileImageUrl = data['profileImageUrl'];
    coverImageUrl = data['coverImageUrl'];
    postCount = data['postCount'];
    friendsCount = data['friendsCount'];
    sharesCount = data['sharesCount'];
  }

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'email': email,
    'name': name,
    'bio': bio,
    'profileImageUrl': profileImageUrl,
    'coverImageUrl': coverImageUrl,
    'postCount': postCount,
    'friendsCount': friendsCount,
    'sharesCount': sharesCount,
  };

}
