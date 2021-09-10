class MessageModel{

  late String dateTime;
  late String senderId;
  late String receiverId;
  late String message;

  MessageModel(){
    dateTime = '';
    senderId = '';
    receiverId = '';
    message = '';
  }

  MessageModel.fromJson(Map<String,dynamic> data){
    dateTime = data['DateTime'];
    senderId = data['senderId'];
    receiverId = data['receiverId'];
    message = data['message'];
  }

}