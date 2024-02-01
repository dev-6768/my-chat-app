import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/widgets/widgets.dart';
import 'controllers/firebase_controllers.dart';

class SendMessage extends StatefulWidget {
  const SendMessage({super.key});

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  final TextEditingController editEmailTextController = TextEditingController();
  final TextEditingController editMessageTextController = TextEditingController();
  @override
  void initState() {
    super.initState();
    editEmailTextController.addListener(() {
      //text: editEmailTextController.text;
    });

    editMessageTextController.addListener(() {
      //text: editMessageTextController.text;
    });
  }

  @override
  void dispose() {
    editEmailTextController.dispose();
    editMessageTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(appBarTitle: "Chat with someone").build(context),
      drawer: DrawerWidget(),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: TextEditingWidget("Enter the email address", "Email address", false, editEmailTextController),
              ),

              SizedBox(height: 10),

              Center(
                child: RichTextWidget(editMessageTextController, "Enter your message", "Message"),
              ),

              SizedBox(height: 10),
              
              Center(
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: BodyTextWidget("Send Message"),
                    onPressed: () async {
                      try{
                        if(editEmailTextController.text != "" && editMessageTextController.text != "") {
                          final recipientId = await UtilFunctions.getUserIdFromEmail(editEmailTextController.text);
                          await SendMessageToReciepient.sendMessageToRecipient(recipientId, FirebaseAuth.instance.currentUser!.uid.toString(), editMessageTextController.text);
                          UtilFunctions.toastMessageService("Message sent successfully !");
                        }
                        
                        else{
                          UtilFunctions.toastMessageService("Please enter email and message to continue.");
                        }
                      }

                      catch(err) {
                        UtilFunctions.toastMessageService("Could not send message. Please try again later.");
                      }
                      
                    }
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}