import 'package:flutter/material.dart';
import 'widgets/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'controllers/string_controller.dart';
import 'controllers/firebase_controllers.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final editTextEmailController = TextEditingController();
  final editTextPasswordController = TextEditingController();
  final editTextAboutController = TextEditingController();
  final editTextConfirmController = TextEditingController();

  @override
  void initState() {
    super.initState();
    editTextEmailController.addListener(() {
      //text: editTextEmailController.text;
    });

    editTextPasswordController.addListener(() {
      //text: editTextPasswordController.text;
    });

    editTextAboutController.addListener(() {
      //text: editTextAboutController.text;
    });

    editTextConfirmController.addListener(() {
      //text: editTextConfirmController.text;
    });
  }

  @override
  void dispose() {
    editTextEmailController.dispose();
    editTextPasswordController.dispose();
    editTextAboutController.dispose();
    editTextConfirmController.dispose();
    super.dispose();
  }

  String uploadImage = defaultContactImage;

  void setProfileImageForUser(String url) {
    setState(() {
      uploadImage = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(appBarTitle: "Register Page",).build(context),
      drawer: DrawerWidget(),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children:[
              Center(
                child: HeadingTextView(
                  "Welcome to the register page !"
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
                    final url = await UploadImageToCloudFirestore.uploadImageToFirebaseStorage("GALLERY", stringIdentifier: "ProfileImage");
                    if(url == "NO") {
                      setProfileImageForUser(defaultContactImage);
                    }

                    else{
                      setProfileImageForUser(url);
                    }
                    
                    //Navigator.pushNamedAndRemoveUntil(context, homeRoute, (route) => false);
                  }
                ),
              ),

              SizedBox(height: 10),

              TextEditingWidget("Enter your email", "Email", false, editTextEmailController, initialValue: ""),

              SizedBox(height: 10),

              TextEditingWidget("Enter your password", "Password", true, editTextPasswordController, initialValue: ""),

              SizedBox(height: 10),

              TextEditingWidget("Write something about yourself.", "Something about yourself", false, editTextAboutController, initialValue: ""),
            
              SizedBox(height: 10),

              TextEditingWidget("Confirm your password", "Confirm password", true, editTextConfirmController, initialValue: ""),

              SizedBox(height: 10),
              SizedBox(height: 10),

              Center(
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                  onPressed: () async { 
                    if(editTextPasswordController.text == editTextConfirmController.text) {
                      if(editTextEmailController.text == "" || editTextPasswordController.text == "" || editTextAboutController.text == "" || editTextConfirmController.text == "") { 
                        UtilFunctions.toastMessageService("Please fill up the required details.");
                      }

                      else{
                        try {
                          if(uploadImage != "NO") {
                            await UserDataCloudFirestore.addUserDataToCloudFirestore(uploadImage, editTextEmailController.text, editTextPasswordController.text, editTextAboutController.text);
                          }

                          else{
                            UtilFunctions.toastMessageService("Some problem occured while loading image. Please try again later.");
                          }
                        }

                        catch(err) {
                          UtilFunctions.toastMessageService("Please fill up the details to proceed.");
                        }
                        
                      }
                    }

                    else {
                      UtilFunctions.toastMessageService("Password and confirm password not equal. Please check again.");
                    }
                    
                  },

                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontFamily: GoogleFonts.calligraffitti().fontFamily,
                      fontSize: 14.0
                    ),
                  ),
                ),
                )
                
              ),

              SizedBox(height: 10),

              Center(
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route) => false);
                  },

                  child: Text(
                    "Login instead",
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
}