import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/controllers/firebase_controllers.dart';
import 'widgets/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'controllers/string_controller.dart';
import 'controllers/data_classes.dart';
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  String uploadImage = "";

  void setStateOfProfileImage(String url) {
    setState(() {
      uploadImage = url;
    });
  }

  static Future<UserData> getDataForCurrentInstance() async {
    if(FirebaseAuth.instance.currentUser != null) {
      final UserData profileData = await UserDataCloudFirestore.getUserDataFromCloudFirestore(FirebaseAuth.instance.currentUser!.uid.toString());
      //return profileData;
      return profileData;
    }

    else{
      UtilFunctions.toastMessageService("Login first to edit the profile.");
      return UserData(image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQUL60wz0ZQehzVxJhRVpy0Nx8byV3nNdFJwwSVvWFXNw&s", about: "Sign in to know about your story", email: "Sign in to know your email");
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
                      child: Text("Could Not Fetch Data.", textScaleFactor: 1.5,),
                    ),
                  ],
                ),
              ),
            )
        );
        }

        else if(snapshot.hasData) {
          final data = snapshot.data as UserData;
          final editTextAboutController = TextEditingController(text: data.about!);
          uploadImage = data.image!;
          @override
          void initState() {
            super.initState();
            editTextAboutController.addListener(() {
              //text: editTextAboutController.text;
            });
          }

          @override
          void dispose() {
            editTextAboutController.dispose();
            super.dispose();
          }

          if(data != UserData(currentUser: "")) {
            return Scaffold(
            appBar: AppBarWidget(appBarTitle: "Edit Profile").build(context),
            drawer: DrawerWidget(),
            body: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  children:[
                    Center(
                      child: HeadingTextView(
                        "Welcome to the edit profile page !"
                      ),
                    ),

                    SizedBox(height: 10),

                    Center(
                      child: InkWell(
                        child: CircleAvatar(
                          backgroundImage: Image.network(uploadImage).image,
                          radius: 100.0,
                        ),

                        onTap: () async {
                          final String url = await UploadImageToCloudFirestore.uploadImageToFirebaseStorage("GALLERY", stringIdentifier: "ProfileImage");
                          if(url != "NO"){
                            setStateOfProfileImage(url);
                          }

                          else{
                            setStateOfProfileImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQUL60wz0ZQehzVxJhRVpy0Nx8byV3nNdFJwwSVvWFXNw&s");
                          }
                          
                        }
                      ),
                    ),

                    SizedBox(height: 10),

                    TextEditingWidget("Write something about yourself.", "Something about yourself", false, editTextAboutController, initialValue: data.about!),

                    SizedBox(height: 10),

                    Center(
                      child: Container(
                        width: double.infinity,
                        child: ElevatedButton(
                        onPressed: () {
                          if(editTextAboutController.text != "") {
                            if(FirebaseAuth.instance.currentUser != null) {
                              final userId = FirebaseAuth.instance.currentUser!.uid.toString();
                              UserDataCloudFirestore.updateUserDataToCloudFirestore(uploadImage, editTextAboutController.text, userId);
                              UtilFunctions.toastMessageService("Data updated successfully.");
                            }

                            else{
                              UtilFunctions.toastMessageService("Login first to get access to profile.");
                            }
                            
                          }

                          else{
                            UtilFunctions.toastMessageService("Please write something about yourself.");
                          }
                          
                        },

                        child: Text(
                          "Edit profile",
                          style: TextStyle(
                            fontFamily: GoogleFonts.calligraffitti().fontFamily,
                            fontSize: 14.0
                          ),
                        ),
                      ),
                      )
                      
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
                      child: HeadingTextView("could not display required data"),
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