import 'package:flutter/material.dart';
import 'package:my_chat_app/controllers/container_classes.dart';
import 'package:my_chat_app/widgets/widgets.dart';
//import 'package:my_chat_app/controllers/string_controller.dart';
import 'controllers/firebase_controllers.dart';
import 'controllers/data_classes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  String uploadImage = "";

  void setStateOfProfileImage(String url) {
    setState(() {
      uploadImage = url;
    });
  }

  static Future<List<UserData>> getDataForCurrentInstance() async {
    if(FirebaseAuth.instance.currentUser != null) {
      final List<UserData> profileData = await GetUserChatDataFromFirebase.getUserData(FirebaseAuth.instance.currentUser!.uid.toString());
      final UserData currentLoggedInUser = await UserDataCloudFirestore.getUserDataFromCloudFirestore(FirebaseAuth.instance.currentUser!.uid.toString());

      profileData.add(currentLoggedInUser);
      return profileData;
    }

    else{
      UtilFunctions.toastMessageService("Login first to access required chat data.");
      return [UserData(image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQUL60wz0ZQehzVxJhRVpy0Nx8byV3nNdFJwwSVvWFXNw&s", email: "Login to access chat data", about: "Login to access chat data", currentUser: "sanidhya")];
    }

    
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(builder: (ctx, snapshot){
      if(snapshot.connectionState == ConnectionState.done) {
        if(snapshot.hasError){
          return Scaffold(
            appBar: AppBarWidget(appBarTitle: "Could not fetch data.").build(context),
            drawer: DrawerWidget(),

            body: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),

              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Text("Could Not Fetch Data. Please try again later.", textScaleFactor: 1.5,),
                    ),
                  ],
                ),
              ),
            )
        );
        }

        else if(snapshot.hasData) {
          final data = snapshot.data as List<UserData>;

          if(data != [UserData(image: "", email: "", about: "", currentUser: "")] && data != []) {
            return Scaffold(
            appBar: AppBarWidget(appBarTitle: "Sasta Whatsapp").build(context),
            drawer: DrawerWidget(),
            body: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  children:[

                    HeadingTextView(
                      "Chats"
                    ),

                    SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),  
                        itemCount: data.length - 1,
                        itemBuilder: (context, index) {
                          return HomeListViewData(
                            itemDesc: data[index],
                            receiverEmailId: data[data.length - 1].email,
                            receiverImage: data[data.length - 1].image,
                          );
                        },
                      ),
                    ),

                    
                  ]
                ),
              ),
            ),
          );
          }

          else {
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
      future: getDataForCurrentInstance(),
    );
  }
}