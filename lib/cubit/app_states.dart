abstract class AppStates{}

class AppInitialState extends AppStates{}

class AppGetUserLoadingState extends AppStates{}
class AppGetUserSuccessState extends AppStates{}
class AppGetUserErrorState extends AppStates{}

class AppAssignUserLoadingState extends AppStates{}
class AppAssignUserSuccessState extends AppStates{}
class AppAssignUserErrorState extends AppStates{}

class AppUpdateProfileLoadingState extends AppStates{}
class AppUpdateProfileSuccessState extends AppStates{}
class AppUpdateProfileErrorState extends AppStates{}

class AppUploadImageLoadingState extends AppStates{}
class AppUploadImageSuccessState extends AppStates{}
class AppUploadImageErrorState extends AppStates{}

class AppDownloadImageLoadingState extends AppStates{}
class AppDownloadImageSuccessState extends AppStates{}
class AppDownloadImageErrorState extends AppStates{}

class AppGetFriendsLoadingState extends AppStates{}
class AppGetFriendsSuccessState extends AppStates{}
class AppGetFriendsErrorState extends AppStates{}

class AppAddFriendLoadingState extends AppStates{}
class AppAddFriendSuccessState extends AppStates{}
class AppAddFriendErrorState extends AppStates{}

/// posting
class AppPostingLoadingState extends AppStates{}
class AppPostingSuccessState extends AppStates{}
class AppPostingErrorState extends AppStates{}

class AppGetUserPostsLoadingState extends AppStates{}
class AppGetUserPostsSuccessState extends AppStates{}
class AppGetUserPostsErrorState extends AppStates{}

class AppGetHomePostsLoadingState extends AppStates{}
class AppGetHomePostsSuccessState extends AppStates{}
class AppGetHomePostsErrorState extends AppStates{}

class AppPostLikeLoadingState extends AppStates{}
class AppPostLikeSuccessState extends AppStates{}
class AppPostLikeErrorState extends AppStates{}

class AppPostingCommentLoadingState extends AppStates{}
class AppPostingCommentSuccessState extends AppStates{}
class AppPostingCommentErrorState extends AppStates{}

/// chatting
class AppSendMessageLoadingState extends AppStates{}
class AppSendMessageSuccessState extends AppStates{}
class AppSendMessageErrorState extends AppStates{}

class AppGetChatLoadingState extends AppStates{}
class AppGetChatSuccessState extends AppStates{}
class AppGetChatErrorState extends AppStates{}

class AppGetAllChatsLoadingState extends AppStates{}
class AppGetAllChatsSuccessState extends AppStates{}
class AppGetAllChatsErrorState extends AppStates{}