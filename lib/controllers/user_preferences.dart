import 'package:flutter/material.dart';
import 'package:notes_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static UserPreferences _instance;
  SharedPreferences _prefs;

  static const String KEY_IS_LOGGED = "IS_LOGGED";
  static const String KEY_LOCALE = "LOCALE";

  static const String KEY_UID = "UID";
  static const String KEY_FIRST_NAME = "FIRST_NAME";
  static const String KEY_LAST_NAME = "LAST_NAME";
  static const String KEY_EMAIL = "EMAIL";
  static const String KEY_PHONE = "PHONE";
  static const String KEY_PASSWORD = "PASSWORD";

  static const String KEY_NUMBER_OF_CATEGORIES = "NUMBER_OF_CATEGORIES";
  static const String KEY_NUMBER_OF_DONE_NOTES = "NUMBER_OF_DONE_NOTES";
  static const String KEY_NUMBER_OF_WAITING_NOTES = "NUMBER_OF_WAITING_NOTES";

  UserPreferences._() {
    _initialize();
  }

  static UserPreferences get instance {
    if (_instance != null) return _instance;

    return _instance = UserPreferences._();
  }

  void _initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get preferences {
    return _prefs;
  }

  Future<void> saveUser(User user) async {
    await _prefs.setString(KEY_UID, user.uid);
    await _prefs.setString(KEY_FIRST_NAME, user.firstName);
    await _prefs.setString(KEY_LAST_NAME, user.lastName);
    await _prefs.setString(KEY_EMAIL, user.email);
    await _prefs.setString(KEY_PHONE, user.phone);
    await _prefs.setString(KEY_PASSWORD, user.password);
    await _prefs.setBool(KEY_IS_LOGGED, true);
  }

  User getUser() {
    String uid = _prefs.get(KEY_UID);
    String firstName = _prefs.getString(KEY_FIRST_NAME);
    String lastName = _prefs.getString(KEY_LAST_NAME);
    String email = _prefs.getString(KEY_EMAIL);
    String phone = _prefs.getString(KEY_PHONE);
    String password = _prefs.getString(KEY_PASSWORD);
    // print("uid pref =>> $uid");
    return User(
      uid: uid,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      password: password,
    );
  }

  Future<bool> clear() async {
    Locale locale = UserPreferences.instance.getLocale();
    bool isCleared = await _prefs.clear();
    await UserPreferences.instance.setLocale(locale);
    return isCleared;
  }

  bool isLogged() {
    bool isLogged = _prefs.getBool(KEY_IS_LOGGED);
    return isLogged == null ? false : isLogged;
  }

  Future<void> setLocale(Locale locale) async{
    // print("new locale $locale");
    await _prefs.setString(KEY_LOCALE, locale.languageCode);
  }

  Locale getLocale() {
    try{
      String languageCode = _prefs.get(KEY_LOCALE);
      // print("is locale $languageCode ");
      if(languageCode.isNotEmpty){
        if(languageCode == "en"){
          return Locale('en', 'US');
        }else{
          return Locale('ar', 'SA');
        }
      }
    }catch(e){
      print("Error locale ");
    }
    return Locale('en', 'US');
  }

  String getNumberOfCategories(){
    String numberOfCategories = _prefs.getString(KEY_NUMBER_OF_CATEGORIES);
    return numberOfCategories == null ? "0" : numberOfCategories;
  }

  Future<void> setNumberOfCategories(String numberOfCategories) async {
    await _prefs.setString(KEY_NUMBER_OF_CATEGORIES, numberOfCategories);
  }

  String getNumberOfDoneNotes(){
    String numberOfDoneNotes = _prefs.getString(KEY_NUMBER_OF_DONE_NOTES);
    return numberOfDoneNotes == null ? "0" : numberOfDoneNotes;
  }

  Future<void> setNumberOfDoneNotes(String numberOfDoneNotes) async {
    await _prefs.setString(KEY_NUMBER_OF_DONE_NOTES, numberOfDoneNotes);
  }

  String getNumberOfWaitingNotes(){
    String numberOfWaitingNotes = _prefs.getString(KEY_NUMBER_OF_WAITING_NOTES);
    return numberOfWaitingNotes == null ? "0" : numberOfWaitingNotes;
  }

  Future<void> setNumberOfWaitingNotes(String numberOfWaitingNotes) async {
    await _prefs.setString(KEY_NUMBER_OF_WAITING_NOTES, numberOfWaitingNotes);
  }

}
