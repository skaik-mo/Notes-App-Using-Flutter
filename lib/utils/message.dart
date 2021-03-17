import 'package:flutter/material.dart';

class Message {
  GlobalKey<ScaffoldState> _scaffoldKey;

  Message(this._scaffoldKey);

  void showMessage(String message, {isError = false}) {
    // ignore: deprecated_member_use
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }
}
