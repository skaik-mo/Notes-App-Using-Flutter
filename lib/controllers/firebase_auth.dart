import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/controllers/user_preferences.dart';
import 'package:notes_app/locale/AppLocalizations.dart';
import 'package:notes_app/models/user.dart';
import 'package:notes_app/utils/message.dart';

class FBAuth {
  GlobalKey<ScaffoldState> _scaffoldKey;
  BuildContext context;
  Message _message;

  FBAuth(this._scaffoldKey, this.context) {
    _message = Message(_scaffoldKey);
  }

  Future<String> getDocumentID(String uid) async {
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection('User').getDocuments();
    List<DocumentSnapshot> documents = querySnapshot.documents;
    for (var document in documents) {
      if (document.data['uid'] == uid) {
        return document.documentID;
      }
    }
    return "";
  }

  Future<void> getUserDocument(User user) async {
    String documentID = await getDocumentID(user.uid);
    DocumentReference documentReference =
        Firestore.instance.collection('User').document(documentID);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    user.firstName = documentSnapshot.data['firstName'];
    user.lastName = documentSnapshot.data['lastName'];
    user.phone = documentSnapshot.data['phone'];

    //Shared Preferences
    await UserPreferences.instance.saveUser(user);
  }

  Future<bool> signIn(User user) async {
    try {
      AuthResult authResult =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      user.uid = authResult.user.uid;
      //Get other data[first name, lsat name, phone] for user
      await getUserDocument(user);
      //Message
      _message.showMessage(AppLocalizations.of(context)
          .translate('loggedInSuccessfullyWelcomeBack'));
      return true;
    } catch (e) {
      // print("error11 => ${e.message}");
      _message.showMessage(e.message, isError: true);
    }
    return false;
  }

  Future<bool> createUser(User user) async {
    try {
      DocumentReference documentReference =
          await Firestore.instance.collection("User").add(
        {
          'uid': user.uid,
          'firstName': user.firstName,
          'lastName': user.lastName,
          'phone': user.phone
        },
      );
      //Shared Preferences
      await UserPreferences.instance.saveUser(user);

      _message.showMessage(AppLocalizations.of(context)
          .translate("accountCreatedSuccessfullyWelcome"));
      return true;
    } catch (e) {
      // print('error create user =>> ${e.message}');
      _message.showMessage(e.message, isError: true);
    }
    return false;
  }

  Future<bool> signUp(User user) async {
    try {
      AuthResult authResult =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      user.uid = authResult.user.uid;
      //save info user
      bool isCreate = await createUser(user);
      //Message
      return isCreate;
    } catch (e) {
      // print("error sign up => ${e.message} ");
      _message.showMessage(e.message, isError: true);
    }
    return false;
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void updateUser(User user) async {
    try {
      String documentID = await getDocumentID(user.uid);
      await Firestore.instance
          .collection("User")
          .document(documentID)
          .updateData({
        'uid': user.uid,
        'firstName': user.firstName,
        'lastName': user.lastName,
        'phone': user.phone,
      });
    } catch (e) {
      // print(e.message);
      _message.showMessage(e.message, isError: true);
    }
  }

  Future<bool> editUser(User newUser) async {
    User oldUser = UserPreferences.instance.getUser();
    try {
      AuthCredential authCredential = EmailAuthProvider.getCredential(
        email: oldUser.email,
        password: oldUser.password,
      );
      var authResult =
          await FirebaseAuth.instance.signInWithCredential(authCredential);
      FirebaseUser firebaseUser = authResult.user;
      await firebaseUser.updateEmail(newUser.email);
      newUser.uid = firebaseUser.uid;
      newUser.password = oldUser.password;
      updateUser(newUser);
      await UserPreferences.instance.saveUser(newUser);
      _message.showMessage(
          AppLocalizations.of(context).translate("editProfileSuccessfully"));
      return true;
    } catch (e) {
      // print(e.message);
      _message.showMessage(e.message, isError: true);
    }
    return false;
  }

// void currentUser() async {
//   FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
//   if (firebaseUser != null) {
//     print('User is ${firebaseUser.email}');
//     return;
//   }
//   print('No Logged in User');
// }
//
//
// void emailVerified() async {
//   FirebaseUser user = await FirebaseAuth.instance.currentUser();
//   await user.reload();
//
//   print('is Email Verified ${user.isEmailVerified}');
//   if (!user.isEmailVerified) {
//     await user.sendEmailVerification();
//   }
// }
//
// Future<bool> resetPassword() async {
//   FirebaseUser user = await FirebaseAuth.instance.currentUser();
//   try {
//     await FirebaseAuth.instance.sendPasswordResetEmail(email: user.email);
//     showMessage("Reset password email sent successfully...");
//     return true;
//   } catch (e) {
//     showMessage(e.message, isError: true);
//   }
//   return false;
// }
}
