import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_chat_app/controllers/container_classes.dart';
import 'package:my_chat_app/controllers/data_classes.dart';
//import 'package:my_chat_app/widgets/widgets.dart';

class StreamBuilderForChat extends StatefulWidget {
  //const StreamBuilderForChat({super.key});
  final String senderImage;
  final String receiverImage;
  final String senderEmailId;
  final String receiverEmailId;
  final List<MessageData> data;
  final String recipientUid;
  final String userUid;

  StreamBuilderForChat(this.senderImage, this.receiverImage, this.senderEmailId, this.receiverEmailId, this.data, this.recipientUid, this.userUid);

  @override
  State<StreamBuilderForChat> createState() => _StreamBuilderForChatState(senderImage, receiverImage, senderEmailId, receiverEmailId, this.data, recipientUid, userUid);
}

class _StreamBuilderForChatState extends State<StreamBuilderForChat> {
  final String senderImage;
  final String receiverImage;
  final String senderEmailId;
  final String receiverEmailId;
  final List<MessageData> data;
  final String recipientUid;
  final String userUid;

  _StreamBuilderForChatState(this.senderImage, this.receiverImage, this.senderEmailId, this.receiverEmailId, this.data, this.recipientUid, this.userUid);


  @override
  Widget build(BuildContext context) {
    var firestoreFromTo;
    var firestoreToFrom;
    return StreamBuilder(
    stream: FirebaseFirestore.instance.collection("MessageData").where("from", isEqualTo: userUid).where("to", isEqualTo: recipientUid).snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Center(
          child: CircularProgressIndicator()
        );
      } else { 
          firestoreFromTo = snapshot.data!.docs;

          return StreamBuilder(
            stream: FirebaseFirestore.instance.collection("MessageData").where("from", isEqualTo: recipientUid).where("to", isEqualTo: userUid).snapshots(),
            builder: (context, snapshotNested) {
              if(!snapshotNested.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              else{
                firestoreToFrom = snapshotNested.data!.docs;

                List<MessageData> grandMessageList = [];

                for(int i=0; i<firestoreFromTo.length; i++) {
                  final element = firestoreFromTo[i];
                  final messageObject = MessageData(to: element['to'].toString(), from: element['from'].toString(), date: element['date'].toString(), message: element['message'].toString());
                  grandMessageList.add(messageObject);
                }

                for(int i=0; i<firestoreToFrom.length; i++) {
                  final element = firestoreToFrom[i];
                  final messageObject = MessageData(to: element['to'].toString(), from: element['from'].toString(), date: element['date'].toString(), message: element['message'].toString());
                  grandMessageList.add(messageObject);
                }

                grandMessageList.sort((a, b) => a.date!.compareTo(b.date!));

                return SingleChildScrollView(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: grandMessageList.length,
                    itemBuilder: (context, index) {
                      return ChatListViewData(
                        itemDesc: grandMessageList[index],
                        senderImage: senderImage,
                        senderEmailId: senderEmailId,
                        receiverEmailId: receiverEmailId,
                        receiverImage: receiverImage,
                      );
                    }
                  )
                );
              }
            }
          );
          
        }
      }
    );
  }
}