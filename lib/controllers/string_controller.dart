var appBarWidgetString = "";
var hintTextForTextEditingController = "";
var labelTextForTextEditingController = "";

//routes names
String homeRoute = "/";
String loginRoute = "/login";
String registerRoute = "/register";
String editProfileRoute = "/editprofile";
String chatWindowForUserRoute = "/chatwindow";
String sendMessageRoute = "/sendmessage";

String defaultContactImage = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQUL60wz0ZQehzVxJhRVpy0Nx8byV3nNdFJwwSVvWFXNw&s";

String appBarWidgetStringFunction(String value) {
  appBarWidgetString = value;
  return appBarWidgetString;
}

String hintTextForTextEditingControllerFunction(String value) {
  hintTextForTextEditingController = value;
  return hintTextForTextEditingController;
}

String labelTextForTextEditingControllerFunction(String value) {
  labelTextForTextEditingController = value;
  return labelTextForTextEditingController;
}