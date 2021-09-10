class CurrentUser {
  static String? uid;
  static String? email;
  static String? name;
  static String bio = 'Welcome to my profile...';
  static String profileImageUrl = 'https://firebasestorage.googleapis.com/v0/b/social-media-c648d.appspot.com/o/Defaults%2FprofileImage%2Fdefault_profile_image_for_users.jpg?alt=media&token=0c5ac708-3603-44cb-bbe9-d5641e82ab64';
  static String coverImageUrl = 'https://firebasestorage.googleapis.com/v0/b/social-media-c648d.appspot.com/o/Defaults%2FprofileImage%2Fdefault_cover_image_for_users.jpg?alt=media&token=e33b7e59-7a2b-46ba-95f5-a1d4137e1142';
  static int postCount = 0;
  static int friendsCount = 0;
  static int sharesCount = 0;


  CurrentUser(sentUid, sentEmail, sentName) {
    uid = sentUid;
    email = sentEmail;
    name = sentName;
  }

  CurrentUser.fromJson(Map<String, dynamic>? data) {
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

  static Map<String, dynamic> toMap() => {
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
