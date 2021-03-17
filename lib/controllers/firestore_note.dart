import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/controllers/user_preferences.dart';
import 'package:notes_app/locale/AppLocalizations.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/models/user.dart';
import 'package:notes_app/utils/message.dart';

class FSNote {
  GlobalKey<ScaffoldState> _scaffoldKey;
  BuildContext context;
  Message _message;

  FSNote(this._scaffoldKey, this.context) {
    _message = Message(_scaffoldKey);
  }

  Future<void> waitingOrDone() async{
    int numberOfDoneNotes = 0;
    int numberOfWaitingNotes = 0;
    User _user = UserPreferences.instance.getUser();

    QuerySnapshot querySnapshot = await Firestore.instance.collection("Note").getDocuments();
    List<DocumentSnapshot> documents = querySnapshot.documents;
    for (var document in documents) {
      if (_user.uid == document.data["uid"]) {
        if(document.data["status"] == true){
          numberOfDoneNotes++;
        }else{
          numberOfWaitingNotes++;
        }
      }
    }
    await UserPreferences.instance.setNumberOfDoneNotes(numberOfDoneNotes.toString());
    await UserPreferences.instance.setNumberOfWaitingNotes(numberOfWaitingNotes.toString());

  }

  //Create category
  Future<bool> createNote(String categoryId, Note note) async {
    try {
      User _user = UserPreferences.instance.getUser();
      DocumentReference documentReference =
          await Firestore.instance.collection("Note").add({
        "uid": _user.uid,
        "categoryId": categoryId,
        "titleNote": note.titleNote,
        "description": note.description,
        "status": false,
      });
      //Message
      _message.showMessage(
          AppLocalizations.of(context).translate("noteSavedSuccessfully"));
      return true;
    } catch (e) {
      //Message ERROR
      _message.showMessage(e.message, isError: true);
    }
    return false;
  }

//read Notes
  Future<List<DocumentSnapshot>> getNotes(String categoryId) async {
    List<DocumentSnapshot> notes = [];
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("Note").getDocuments();
    List<DocumentSnapshot> documents = querySnapshot.documents;
    for (var document in documents) {
      if (categoryId == document.data["categoryId"]) {
        notes.add(document);
      }
    }
    await waitingOrDone();
    return notes;
  }

//update Note
  Future<bool> updateNote(Note note) async {
    try {
      await Firestore.instance.collection("Note").document(note.id).updateData(
          {"titleNote": note.titleNote, "description": note.description});
      //message
      _message.showMessage(
          AppLocalizations.of(context).translate("noteUpdatedSuccessfully"));
      return true;
    } catch (e) {
      //Message ERROR
      _message.showMessage(e.message, isError: true);
    }
    return false;
  }

  Future<bool> updateStatusNote(Note note) async {
    try {
      await Firestore.instance
          .collection("Note")
          .document(note.id)
          .updateData({"status": note.status});
      return true;
    } catch (e) {
      //Message ERROR
      // _message.showMessage(e.message, isError: true);
    }
    return false;
  }

//delete Note
  void deleteNote(String id) async {
    await Firestore.instance.collection("Note").document(id).delete();
    await waitingOrDone();
  }
}
