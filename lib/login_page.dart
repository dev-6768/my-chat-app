import 'package:flutter/material.dart';
import 'package:my_chat_app/controllers/firebase_controllers.dart';
import 'widgets/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'controllers/string_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final editTextEmailController = TextEditingController();
  final editTextPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    editTextEmailController.addListener(() {
      //text: editTextEmailController.text;
    });

    editTextPasswordController.addListener(() {
      //text: editTextPasswordController.text;
    });
  }

  @override
  void dispose() {
    editTextEmailController.dispose();
    editTextPasswordController.dispose();
    super.dispose();
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(appBarTitle: "Login Page",).build(context),
      drawer: DrawerWidget(),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children:[
              Center(
                child: HeadingTextView(
                  "Welcome to the login page !"
                ),
              ),

              SizedBox(height: 10),

              TextEditingWidget("Enter your email", "Email", false, editTextEmailController),

              SizedBox(height: 10),

              TextEditingWidget("Enter your password", "Password", true, editTextPasswordController),

              SizedBox(height: 10),
              SizedBox(height: 10),

              Center(
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                  onPressed: () async {
                    try {
                      if(editTextEmailController.text != "" && editTextPasswordController.text != "") {
                        UserDataCloudFirestore.signInUser(editTextEmailController.text, editTextPasswordController.text);
                        UtilFunctions.persistStateLogin();
                      }

                      else {
                        UtilFunctions.toastMessageService("Incorrect email or password. Try again later.");
                      }
                    }

                    catch(err) {
                      UtilFunctions.toastMessageService("Some error encountered. Please try again later.");
                    }
                  },

                  child: Text(
                    "Login",
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
                    Navigator.pushNamedAndRemoveUntil(context, registerRoute, (route) => false);
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
            ]
          ),
        ),
      ),
    );
  }
}