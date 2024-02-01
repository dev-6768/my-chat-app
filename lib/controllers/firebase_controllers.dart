import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'data_classes.dart';
import 'package:firebase_core/firebase_core.dart';

class UserDataCloudFirestore {
  static Future<void> addUserDataToCloudFirestore(String image, String email, String password, String about) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      if(FirebaseAuth.instance.currentUser != null) {
        FirebaseAuth.instance.signOut();
      }
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      final currentUser = FirebaseAuth.instance.currentUser!.uid.toString();

      final firestore = FirebaseFirestore.instance.collection("UserData");
      final currentDateTime = DateTime.now().toString();
      await firestore.doc(currentUser).set({"image":image, "email":email, "password":password, "about":about, "date_last_updated":currentDateTime, "currentUser": currentUser});  
      UtilFunctions.toastMessageService("Account created successfully.");
    }

    catch(err) {
      UtilFunctions.toastMessageService("Could not register user. Please try again.");
    }
    
  }

  static void signInUser(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      UtilFunctions.toastMessageService("Logged in successfully");
    }

    catch(err) {
      UtilFunctions.toastMessageService("Some error occured while signing in. Please try again later.");
    }
  }

  static void logOutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
      UtilFunctions.toastMessageService("User logged out successfully.");
    }

    catch(err) {
      UtilFunctions.toastMessageService("Some problem occured while logging out the user. Please try again later.");
    }
  }

  static Future<void> updateUserDataToCloudFirestore(String image, String about, String userId) async {
    try{
      final firestore = await FirebaseFirestore.instance.collection("UserData");
      final currentDateTime = DateTime.now();
      await firestore.doc(userId).set({"image":image, "about":about, "date_last_updated": currentDateTime});
    }

    catch(err) {
      UtilFunctions.toastMessageService("Could not update user data. Please try again later.");
    }
    
  }

  static Future<UserData> getUserDataFromCloudFirestore(String userId) async {
    final firestore = await FirebaseFirestore.instance.collection("UserData").doc(userId).get();
    if(firestore.exists) {
      final element = firestore.data();
      final userObject = UserData(email: element?['email'], about: element?['about'], image: element?['image'], currentUser: element?['currentUser'].toString());
      return userObject;
    }

    else {
      return UserData();
    }
    
  }

}

class UploadImageToCloudFirestore {
  static final firebaseStorageInstance = FirebaseStorage.instance;

  static Future<String> uploadImageToFirebaseStorage(String mode, {String stringIdentifier="ProfileImage"}) async {
    if(mode == "GALLERY"){
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) {
        UtilFunctions.toastMessageService("Failed to load image.");
        return "NO";
      }

      else{
        try{
          var currentTime = DateTime.now();
          final storageReference = firebaseStorageInstance.ref().child("$stringIdentifier:$currentTime");
          final uploadTask = storageReference.putFile(File(image.path));
          print(uploadTask);
          var taskSnapshot = await uploadTask;
          var imageUrl = await taskSnapshot.ref.getDownloadURL();
          UtilFunctions.toastMessageService("Image uploaded successfully.");
          return imageUrl;
        }

        catch(err) {
          print(err);
          UtilFunctions.toastMessageService("Failed to upload image. Please try again later.");
          return "NO";
        }
      }
    }

    else {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if(image == null) {
        UtilFunctions.toastMessageService("Failed to load image.");
        return "NO";
      }

      else{
        try{
          var currentTime = DateTime.now();
          final storageReference = firebaseStorageInstance.ref().child("$stringIdentifier:$currentTime");
          final uploadTask = storageReference.putFile(File(image.path));
          var taskSnapshot = await uploadTask;
          var imageUrl = await taskSnapshot.ref.getDownloadURL();
          UtilFunctions.toastMessageService("Image uploaded successfully.");
          return imageUrl;
        }

        catch(err) {
          UtilFunctions.toastMessageService("Failed to upload image. Please try again later.");
          return "NO";
        }
      }
    }
    
  }
}


class GetUserChatDataFromFirebase {
  static Future<List<UserData>> getUserData(String userId) async {
    Set<MessageData> getUserDataSet = Set();
    Set<UserData> getUniqueUserData = Set();
    
    final firestore = await FirebaseFirestore.instance.collection('MessageData').where("from", isEqualTo: userId).get();
    final firestoreReceiver = await FirebaseFirestore.instance.collection('MessageData').where("to", isEqualTo: userId).get();

    for(int i=0;i<firestore.docs.length;i++) {
      final element = firestore.docs[i].data();
      final messageDataObject = MessageData(to: element['to'].toString(), from: element['from'].toString(), message: element['message'].toString(), date: element['date'].toString());
      
      if(!getUserDataSet.contains(messageDataObject)) {
        final userObject = await FirebaseFirestore.instance.collection('UserData').where("currentUser", isEqualTo: messageDataObject.to.toString()).get();
        for(int i=0;i < userObject.docs.length; i++) {
          final element = userObject.docs[i].data();
          final userDataObject = UserData(email: element['email'].toString(), image: element['image'].toString(), currentUser: element['currentUser'].toString(), about: element['about'].toString());
          getUniqueUserData.add(userDataObject);
        }
        
        getUserDataSet.add(messageDataObject);
      }
    }

    for(int i=0;i<firestoreReceiver.docs.length;i++) {
      final element = firestoreReceiver.docs[i].data();
      final messageDataObject = MessageData(to: element['to'].toString(), from: element['from'].toString(), message: element['message'].toString(), date: element['date'].toString());
      
      if(!getUserDataSet.contains(messageDataObject)) {
        final userObject = await FirebaseFirestore.instance.collection('UserData').where("currentUser", isEqualTo: messageDataObject.from.toString()).get();
        for(int i=0;i < userObject.docs.length; i++) {
          final element = userObject.docs[i].data();
          final userDataObject = UserData(email: element['email'].toString(), image: element['image'].toString(), currentUser: element['currentUser'].toString(), about: element['about'].toString());
          getUniqueUserData.add(userDataObject);
        }
        
        getUserDataSet.add(messageDataObject);
      }
    }

    
    return getUniqueUserData.toList();
  }

  

  static Future<List<MessageData>> getChatBetweenTwoPeople(String userId, String reciepientUserId) async {
    List<MessageData> grandMessageList = [];
    final firestoreFromTo = await FirebaseFirestore.instance.collection("MessageData").where("from", isEqualTo: userId).where("to", isEqualTo: reciepientUserId).get();
    final firestoreToFrom = await FirebaseFirestore.instance.collection('MessageData').where("to", isEqualTo: userId).where("from", isEqualTo: reciepientUserId).get();
    for(int i=0; i<firestoreFromTo.docs.length; i++) {
      final element = firestoreFromTo.docs[i].data();
      final messageObject = MessageData(to: element['to'].toString(), from: element['from'].toString(), date: element['date'].toString(), message: element['message'].toString());
      grandMessageList.add(messageObject);
    }

    for(int i=0; i<firestoreToFrom.docs.length; i++) {
      final element = firestoreToFrom.docs[i].data();
      final messageObject = MessageData(to: element['to'].toString(), from: element['from'].toString(), date: element['date'].toString(), message: element['message'].toString());
      grandMessageList.add(messageObject);
    }

    return grandMessageList;
  }


}

class SendMessageToReciepient {
  static Future<void> sendMessageToRecipient(String to, String from, String message) async {
    final firestore = await FirebaseFirestore.instance.collection('MessageData');
    final currentDate = DateTime.now();
    await firestore.doc().set({"to":to, "from":from, "message":message, "date":currentDate});
  }
}


class UtilFunctions {
  static void toastMessageService(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 20.0,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  static void cancelToastMessageService() {
    Fluttertoast.cancel();
  }

  static void persistStateLogin() async {
    final authentication = FirebaseAuth.instanceFor(app: Firebase.app(), persistence: Persistence.NONE);
    await authentication.setPersistence(Persistence.LOCAL);
  }

  static Future<String> getUserIdFromEmail(String email) async {
    String userId = '';
    try {
      final firestore = await FirebaseFirestore.instance.collection("UserData").where("email", isEqualTo: email).get();
      for(int i=0;i<firestore.docs.length;) {
        final element = firestore.docs[i].data();
        userId = element['currentUser'].toString();
        break;
      }

      return userId;
    }

    catch(err) {
      UtilFunctions.toastMessageService("Could not process message. Please try again later.");
      return userId;
    }
    
    
  }
}


