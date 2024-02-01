import 'package:flutter/material.dart';
import 'package:my_chat_app/controllers/string_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_chat_app/controllers/firebase_controllers.dart';

class AppBarWidget extends StatelessWidget {
  final String appBarTitle;
  AppBarWidget({this.appBarTitle = "Sasta whatsapp"});

  //const AppBarWidget({super.key});

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      title: Text(
        appBarTitle,
        style: TextStyle(
          fontFamily: GoogleFonts.calligraffitti().fontFamily,
          fontSize: 15.0,
        ),
      ),
      backgroundColor: Colors.greenAccent,
      centerTitle: true,

    );
  }
}

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: UserAccountsDrawerHeader(
              accountName: Text("hello", textScaleFactor: 1.3),
              accountEmail: Text("hello"),
              margin: EdgeInsets.zero,
              currentAccountPicture: CircleAvatar(backgroundImage: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQUL60wz0ZQehzVxJhRVpy0Nx8byV3nNdFJwwSVvWFXNw&s").image),
            ),
          ),

          ListTile(
            leading: Icon(Icons.home, color: Colors.black),
            title: Text("Home", style:TextStyle(color: Colors.black), textScaleFactor: 1.1),
            onTap: () {
              Navigator.pushNamed(context, homeRoute);
            }
          ),

          ListTile(
            leading: Icon(Icons.email, color: Colors.black),
            title: Text("Edit Profile", style:TextStyle(color: Colors.black), textScaleFactor: 1.1),
            onTap: () async {
              Navigator.pushNamedAndRemoveUntil(context, editProfileRoute, (route) => false);
            }
          ),

          ListTile(
            leading: Icon(Icons.login, color: Colors.black),
            title: Text("Login", style: TextStyle(color: Colors.black), textScaleFactor: 1.1),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route)=>false);
            },
          ),

        
          ListTile(
            leading: Icon(Icons.app_registration, color: Colors.black),
            title: Text("Register", style: TextStyle(color: Colors.black), textScaleFactor: 1.1),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(context, registerRoute, (route) => false);
            }
          ),


          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.black),
            title: Text("Sign out", style: TextStyle(color: Colors.black), textScaleFactor: 1.1),
            onTap: () {
              UserDataCloudFirestore.logOutUser();
            }
          ),

          ListTile(
            leading: Icon(Icons.message, color: Colors.black),
            title: Text("Send message", style: TextStyle(color: Colors.black), textScaleFactor: 1.1),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(context, sendMessageRoute, (route) => false);
            }
          ),
        ],
      ),
    );
  }
}


class HeadingTextView extends StatelessWidget {
  final String textArg;
  HeadingTextView(this.textArg);
  //const HeadingTextView({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      textArg,
      style: TextStyle(
        fontFamily: GoogleFonts.calligraffitti().fontFamily,
        fontSize: 14.0,
      ),

      textScaleFactor: 1.3,
    );
  }
}

class BodyTextWidget extends StatelessWidget {
  final String textArg;
  BodyTextWidget(this.textArg);

  //const BodyTextWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Text(
      textArg,
      style: TextStyle(
        fontFamily: GoogleFonts.calligraffitti().fontFamily,
        fontSize: 14.0,
      ),
    );
  }
}

class TextEditingWidget extends StatefulWidget {
  final String hintText;
  final String labelText;
  final bool obscureText;
  final TextEditingController textController;
  final String initialValue;

  TextEditingWidget(this.hintText, this.labelText, this.obscureText, this.textController, {this.initialValue = ""});
  //const TextEditingWidget({super.key});

  @override
  State<TextEditingWidget> createState() => _TextEditingWidgetState(hintText, labelText, obscureText, textController, initialValue);
}

class _TextEditingWidgetState extends State<TextEditingWidget> {
  final TextEditingController editController = TextEditingController();
  final String hintText;
  final String labelText;
  final bool obscureText;
  final TextEditingController textController;
  final String? initialValue;

  _TextEditingWidgetState(this.hintText, this.labelText, this.obscureText, this.textController, this.initialValue);

  @override
  void initState() {
    super.initState();
    editController.addListener(() {
      //text: editController.text;
    });
  }

  @override
  void dispose() {
    editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        
      ),

      controller: textController,
      initialValue: null,
      obscureText: obscureText,
      enableSuggestions: !obscureText,
      autocorrect: !obscureText,
      
    );
  }
}

class ButtonWidget extends StatefulWidget {
  final String childText;
  final Future<Object?> doSomething;
  ButtonWidget(this.childText, this.doSomething);
  //const ButtonWidget({super.key});

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState(childText, doSomething);
}

class _ButtonWidgetState extends State<ButtonWidget> {
  final String childText;
  final Future<Object?> doSomething;

  _ButtonWidgetState(this.childText, this.doSomething);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => doSomething,

      child: Text(
        childText,
        style: TextStyle(
          fontFamily: GoogleFonts.calligraffitti().fontFamily,
          fontSize: 16.0,
        ),
      ),
    );
  }
}


class RichTextWidget extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final String labelText;
  RichTextWidget(this.textController, this.hintText, this.labelText);


  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: null,
      controller: textController,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        
        hintText: hintText,
        labelText: labelText,
        
        labelStyle: TextStyle(
          fontFamily: GoogleFonts.calligraffitti().fontFamily,
        ),

        hintStyle: TextStyle(
          fontFamily: GoogleFonts.calligraffitti().fontFamily,
          fontSize: 16.0,
        ),
      ),
    );
  }
}


class SendMessageTextWidget extends StatefulWidget {
  final String hintText;
  final String labelText;
  final TextEditingController textController;
  final bool obscureText;
  final String receiverId;
  final String userId;

  SendMessageTextWidget(this.hintText, this.labelText, this.obscureText, this.textController, this.receiverId, this.userId);

  @override
  State<SendMessageTextWidget> createState() => _SendMessageTextWidgetState(hintText, labelText, obscureText, textController, receiverId, userId);
}

class _SendMessageTextWidgetState extends State<SendMessageTextWidget> {
  final String hintText;
  final String labelText;
  final TextEditingController textController;
  final bool obscureText;
  final String receiverId;
  final String userId;

  _SendMessageTextWidgetState(this.hintText, this.labelText, this.obscureText, this.textController, this.receiverId, this.userId);


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        
        suffixIcon: IconButton(
          icon: Icon(Icons.send),
          onPressed: () async {
            try {
              await SendMessageToReciepient.sendMessageToRecipient(receiverId, userId, textController.text);
              UtilFunctions.toastMessageService("Message sent successfully.");
            }

            catch(err) {
              UtilFunctions.toastMessageService("Could not send message. Please try again later.");
            }
            
          },
        ),
      ),

      obscureText: obscureText,
      controller: textController,
      maxLines: null,
    );
  }
}