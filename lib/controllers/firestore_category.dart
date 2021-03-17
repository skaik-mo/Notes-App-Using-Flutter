import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/controllers/firestore_note.dart';
import 'package:notes_app/controllers/user_preferences.dart';
import 'package:notes_app/locale/AppLocalizations.dart';
import 'package:notes_app/models/category.dart';
import 'package:notes_app/models/user.dart';
import 'package:notes_app/utils/message.dart';

class FSCategory {
  GlobalKey<ScaffoldState> _scaffoldKey;
  BuildContext context;
  Message _message;

  FSCategory(this._scaffoldKey, this.context) {
    _message = Message(_scaffoldKey);
  }

  Future<String> numberOfCategories() async{
    List<DocumentSnapshot> document = await getCategories();
    return document.length.toString();
  }

  //Create category
  Future<bool> createCategory(Category category) async {
    try {
      User user = UserPreferences.instance.getUser();
      if (user.uid.isEmpty) {
        _message.showMessage(
            AppLocalizations.of(context).translate("pleaseSignInAgain"),
            isError: true);
        return false;
      }
      DocumentReference documentReference =
          await Firestore.instance.collection("Category").add({
        "uid": user.uid,
        "titleCategory": category.titleCategory,
        "description": category.description
      });
      //Message
      _message.showMessage(
          AppLocalizations.of(context).translate("categorySavedSuccessfully"));
      return true;
    } catch (e) {
      //Message ERROR
      // print("error create category ${e.message}");
      _message.showMessage(e.message, isError: true);
    }
    return false;
  }

//read categories
  Future<List<DocumentSnapshot>> getCategories() async {
    List<DocumentSnapshot> categories = [];
    User user = UserPreferences.instance.getUser();
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("Category").getDocuments();
    List<DocumentSnapshot> documents = querySnapshot.documents;
    for (var document in documents) {
      if (user.uid == document.data["uid"]) {
        categories.add(document);
      }
    }
    await UserPreferences.instance.setNumberOfCategories(categories.length.toString());
    return categories;
  }

//update category
  Future<bool> updateCategory(Category category) async {
    try {
      await Firestore.instance
          .collection("Category")
          .document(category.id)
          .updateData({
        "titleCategory": category.titleCategory,
        "description": category.description
      });
      //message
      _message.showMessage(AppLocalizations.of(context).translate("categoryHasBeenSuccessfullyUpdated"));
      return true;
    } catch (e) {
      //Message ERROR
      // print("error update category ${e.message}");
      _message.showMessage(e.message, isError: true);
    }
    return false;
  }

//delete category
  Future<bool> deleteCategory(Category category) async {
    FSNote _fsNote = FSNote(_scaffoldKey, context);
    List<DocumentSnapshot> notes = await _fsNote.getNotes(category.id);
    for(var note in notes){
      _fsNote.deleteNote(note.documentID);
    }
    await _fsNote.waitingOrDone();
    await Firestore.instance
        .collection("Category")
        .document(category.id)
        .delete();
    return true;
  }

}
