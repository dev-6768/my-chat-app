class UserHomePageData {
  String? recipientImage;
  String? recipientEmailId;
  String? recipientAbout;

  @override
  bool operator ==(Object other) => other is UserHomePageData && recipientEmailId == other.recipientEmailId;
  int get hashCode => Object.hash(recipientEmailId, recipientEmailId); 

  UserHomePageData({this.recipientImage, this.recipientEmailId, this.recipientAbout});
}

class UserData {
  String? email;
  String? image;
  String? about;
  String? currentUser;

  @override
  bool operator ==(Object other) => other is UserData && currentUser == other.currentUser;
  int get hashCode => Object.hash(currentUser, currentUser); 

  UserData({this.email, this.image, this.about, this.currentUser});
}

class MessageData {
  String? to;
  String? from;
  String? message;
  String? date;

  @override
  bool operator ==(Object other) => other is MessageData && to == other.to;
  int get hashCode => Object.hash(to, to); 

  MessageData({this.to, this.from, this.message, this.date});
}

class ChatData {
  String? image;
  String? title;
  String? message;
  String? date;

  ChatData({this.image, this.title, this.message, this.date});
}