import 'package:flutter/material.dart';
import 'package:my_chat_app/controllers/firebase_controllers.dart';
import 'package:my_chat_app/widgets/widgets.dart';
import 'data_classes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_chat_app/chat_window.dart';

class HomeListViewData extends StatelessWidget {
  final UserData itemDesc;
  final String? receiverImage;
  final String? receiverEmailId;

  const HomeListViewData({Key? key, required this.itemDesc, required this.receiverImage, required this.receiverEmailId})
  :assert(receiverEmailId != null,),
  super(key: key);


  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      elevation: 10.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),

      child: ListTile(
        leading: Image.network(itemDesc.image!),
        title: Text(itemDesc.email!),
        subtitle: Text(
          itemDesc.about!,
          style: TextStyle(
            fontFamily: GoogleFonts.calligraffitti().fontFamily,
            fontSize: 12.0,
          ),
        ),

        onTap: () async { 
          UtilFunctions.toastMessageService("before");
          Navigator.push(context, MaterialPageRoute(builder: (ctx) => ChatWindow(FirebaseAuth.instance.currentUser!.uid.toString(), itemDesc.currentUser!, itemDesc.email!, itemDesc.image!, receiverImage!, receiverEmailId!)));
          UtilFunctions.toastMessageService("after");
        },  

      ),
    );
  }
}

class ChatListViewData extends StatelessWidget {
  final MessageData itemDesc;
  final String senderImage;
  final String receiverImage;
  final String senderEmailId;
  final String receiverEmailId;

  const ChatListViewData({Key? key, required this.itemDesc, required this.senderImage, required this.receiverImage, required this.senderEmailId, required this.receiverEmailId});

 //super(key: key);

  @override
  Widget build(BuildContext context) {

    var backgroundColorObject;
    var leadingImage;
    var title;
    var trailing;

    if(FirebaseAuth.instance.currentUser!.uid.toString() == itemDesc.from!) {
      backgroundColorObject = Colors.white;
      leadingImage = receiverImage;
      trailing = senderEmailId;
      title = receiverEmailId;
    }

    else if(FirebaseAuth.instance.currentUser!.uid.toString() == itemDesc.to!) {
      backgroundColorObject = Colors.greenAccent;
      leadingImage = senderImage;
      trailing = receiverEmailId;
      title = senderEmailId;
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      color: backgroundColorObject,
      elevation: 10.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),

      child: ListTile(
        leading: CircleAvatar(backgroundImage: Image.network(leadingImage).image),
        title: BodyTextWidget(title),
        subtitle: BodyTextWidget(itemDesc.message!),
        trailing: Text(
          "$trailing, ${itemDesc.date!}",
          style: TextStyle(
            fontFamily: GoogleFonts.calligraffitti().fontFamily,
            fontSize: 10.0,
          ),
        ),
      ),
    );
  }
}