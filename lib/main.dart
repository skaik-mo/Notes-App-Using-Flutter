import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:notes_app/controllers/user_preferences.dart';
import 'package:notes_app/locale/AppLocalizations.dart';
import 'package:notes_app/screens/auth/login_screen.dart';
import 'package:notes_app/screens/auth/signup_screen.dart';
import 'package:notes_app/screens/categories/add_or_update_category_screen.dart';
import 'package:notes_app/screens/categories/categories_screen.dart';
import 'package:notes_app/screens/launch_screen.dart';
import 'package:notes_app/screens/notes/add_or_update_note_screen.dart';
import 'package:notes_app/screens/notes/notes_screen.dart';
import 'package:notes_app/screens/settings/about_app.dart';
import 'package:notes_app/screens/settings/profile_screen.dart';
import 'package:notes_app/screens/settings/setting_screen.dart';

void main() => runApp(MainApp());

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();

  static void setLocale(BuildContext context, Locale newLocale) async {
    await UserPreferences.instance.setLocale(newLocale);
    _MainAppState state = context.findAncestorStateOfType<_MainAppState>();
    state.setLocale(newLocale);
  }
}

class _MainAppState extends State<MainApp> {
  static Locale _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserPreferences.instance;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ar', 'SA'),
      ],
      // locale: _locale != null ? _locale : Locale('en', 'US'),//default is en
      locale: _locale,
      //default is en
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      initialRoute: '/launchScreen',
      routes: {
        '/launchScreen': (context) => LaunchScreen(),

        //Auth
        '/loginScreen': (context) => LoginScreen(),
        '/signUpScreen': (context) => SignUpScreen(),

        //Categories
        '/categoriesScreen': (context) => CategoriesScreen(),
        '/addOrUpdateCategoryScreen': (context) => AddOrUpdateCategoryScreen(),

        //Notes
        '/notesScreen': (context) => NotesScreen(),
        '/addOrUpdateNotesScreen': (context) => AddOrUpdateNoteScreen(),

        //Settings
        '/settingsScreen': (context) => SettingsScreen(),
        '/aboutApp': (context) => AboutApp(),
        '/profileScreen': (context) => ProfileScreen(),
      },
    );
  }
}
