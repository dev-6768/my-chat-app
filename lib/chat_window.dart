import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/controllers/firebase_controllers.dart';
import 'controllers/data_classes.dart';
import 'package:my_chat_app/widgets/widgets.dart';
import 'widgets/streambuilder_chat.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'controllers/container_classes.dart';

class ChatWindow extends StatefulWidget {
  //const ChatWindow({super.key});
  final String userUid;
  final String recipientUid;
  final String email;
  final String image;
  final String receiverImage;
  final String receiverEmailId;

  ChatWindow(this.userUid, this.recipientUid, this.email, this.image, this.receiverImage, this.receiverEmailId);

  @override
  State<ChatWindow> createState() => _ChatWindowState(userUid, recipientUid, email, image, receiverImage, receiverEmailId);
}

class _ChatWindowState extends State<ChatWindow> {
  final String userUid;
  final String recipientUid;
  final String email;
  final String image;
  final String receiverImage;
  final String receiverEmailId;

  final TextEditingController editMessageTextController = TextEditingController(text: "Enter any message");

  void initState() {
    super.initState();
    editMessageTextController.addListener(() {
      //text: editMessageTextController.text;
    });
  }

  void dispose() {
    editMessageTextController.dispose();
    super.dispose();
  }
  
  _ChatWindowState(this.userUid, this.recipientUid, this.email, this.image, this.receiverImage, this.receiverEmailId);

   Future<List<MessageData>> getDataForCurrentInstance(String userId, String recipientId) async {
    try{
      if(FirebaseAuth.instance.currentUser != null) {
        final List<MessageData> messageDataList = await GetUserChatDataFromFirebase.getChatBetweenTwoPeople(userId, recipientId);
        return messageDataList;
      }

      else{
        final List<MessageData>messageDataList = [MessageData()];
        return messageDataList;
      }
      
    }

    catch(err) {
      UtilFunctions.toastMessageService("$userId, $recipientId $email, $image, Some error occured. Please try again later.");
      return [MessageData()];
    }
    
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(builder: (ctx, snapshot) {
      if(snapshot.connectionState == ConnectionState.done) {
        if(snapshot.hasError) {
          return Scaffold(
            appBar: AppBarWidget(appBarTitle: "Could not fetch data.").build(context),
            drawer: DrawerWidget(),

            body: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),

              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Text("Could Not Fetch Data.", textScaleFactor: 1.5,),
                    ),
                  ],
                ),
              ),
            )
          );
        }

        else if(snapshot.hasData) {
          final data = snapshot.data as List<MessageData>;
          if(data != [MessageData()] || data != []) { 
            return Scaffold(
              appBar: AppBarWidget(appBarTitle: "Chats").build(context),
              drawer: DrawerWidget(),
              body: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Chats between $email and $receiverEmailId",
                      style: TextStyle(
                        fontFamily: GoogleFonts.calligraffitti().fontFamily,
                        fontSize: 16.0,
                      ),
                    ),

                    
                    
                    SizedBox(height: 10),

                    StreamBuilderForChat(image, receiverImage, email, receiverEmailId, data, recipientUid, userUid),

                    SizedBox(height: 10),

                    SendMessageTextWidget("Enter your message", "message", false, editMessageTextController, recipientUid, userUid),

                    // SingleChildScrollView(
                    //   child: ListView.builder(
                    //     shrinkWrap: true,
                    //     physics: NeverScrollableScrollPhysics(),
                    //     itemCount: data.length,
                    //     itemBuilder: (context, index) {
                    //       return ChatListViewData(
                    //         itemDesc: data[index],
                    //         senderImage: image,
                    //         senderEmailId: email,
                    //         receiverEmailId: receiverEmailId,
                    //         receiverImage: receiverImage,
                    //       );
                    //     }
                    //   )
                    // ),
                  ],
                ),
              ),
            ),
            );

          }

          else{
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),

              child: SingleChildScrollView(
                child: Column(
                  children: [
                      Center(
                      child: Text(
                        "Could not display required data.",
                        style: TextStyle(
                          fontFamily: GoogleFonts.lato().fontFamily,
                        ),
                        textScaleFactor: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            );

          }
        }
      }

      return Center(
            child: CircularProgressIndicator(),
      );
    },

    future: getDataForCurrentInstance(userUid, recipientUid),
    
    );
  }
}