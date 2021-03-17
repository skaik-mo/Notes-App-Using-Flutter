import 'package:flutter/material.dart';
import 'package:notes_app/controllers/firebase_auth.dart';
import 'package:notes_app/locale/AppLocalizations.dart';
import 'package:notes_app/models/user.dart';
import 'package:notes_app/utils/app_colors.dart';
import 'package:notes_app/utils/message.dart';
import 'package:notes_app/utils/size_config.dart';
import 'package:notes_app/widgets/note_text_field.dart';
import 'package:notes_app/widgets/note_button.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _firstNameTextEditingController =
      TextEditingController();
  TextEditingController _lastNameTextEditingController =
      TextEditingController();
  TextEditingController _emailTextEditingController = TextEditingController();
  TextEditingController _phoneTextEditingController = TextEditingController();
  TextEditingController _passwordTextEditingController =
      TextEditingController();

  final RoundedLoadingButtonController _btnController =
  RoundedLoadingButtonController();

  FBAuth _fbAuth;
  Message _message;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fbAuth = FBAuth(_scaffoldKey, this.context);
    _message = Message(_scaffoldKey);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _firstNameTextEditingController.dispose();
    _lastNameTextEditingController.dispose();
    _emailTextEditingController.dispose();
    _phoneTextEditingController.dispose();
    _passwordTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      onTap: () {
        //This thing for hide the keyboard
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/launch.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: EdgeInsetsDirectional.only(
              top: SizeConfig.scaleHeight(92),
              start: SizeConfig.scaleWidth(26),
              end: SizeConfig.scaleWidth(26),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context).translate("signUp"),
                  style: TextStyle(
                    color: AppColors.DARK_BLUE_COLOR,
                    fontSize: SizeConfig.scaleTextFont(30),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: SizeConfig.scaleHeight(8),
                ),
                Text(
                  AppLocalizations.of(context).translate("createAnAccount"),
                  style: TextStyle(
                    color: AppColors.HINT_COLOR,
                    fontSize: SizeConfig.scaleTextFont(18),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.scaleHeight(53),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsetsDirectional.zero,
                    children: [
                      Card(
                        elevation: 5,
                        color: Colors.white,
                        margin: EdgeInsetsDirectional.only(
                          //top: SizeConfig.scaleHeight(53),
                          bottom: SizeConfig.scaleHeight(30),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusDirectional.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(
                            top: SizeConfig.scaleHeight(34),
                            bottom: SizeConfig.scaleHeight(32),
                            start: SizeConfig.scaleWidth(15),
                            end: SizeConfig.scaleWidth(15),
                          ),
                          child: Column(
                            children: [
                              NoteTextField(
                                AppLocalizations.of(context)
                                    .translate("firstName"),
                                _firstNameTextEditingController,
                              ),
                              SizedBox(
                                height: SizeConfig.scaleHeight(20),
                              ),
                              NoteTextField(
                                AppLocalizations.of(context)
                                    .translate("lastName"),
                                _lastNameTextEditingController,
                              ),
                              SizedBox(
                                height: SizeConfig.scaleHeight(20),
                              ),
                              NoteTextField(
                                AppLocalizations.of(context).translate("email"),
                                _emailTextEditingController,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              SizedBox(
                                height: SizeConfig.scaleHeight(20),
                              ),
                              NoteTextField(
                                AppLocalizations.of(context).translate("phone"),
                                _phoneTextEditingController,
                                keyboardType: TextInputType.phone,
                              ),
                              SizedBox(
                                height: SizeConfig.scaleHeight(20),
                              ),
                              NoteTextField(
                                AppLocalizations.of(context)
                                    .translate("password"),
                                _passwordTextEditingController,
                                obscureText: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                      NoteButton(
                        AppLocalizations.of(context).translate("signUp"),
                        height: 53,
                        borderRadius: 26.5,
                        btnController: _btnController,
                        callBack: () {
                          signUp(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  User getUser() {
    return User(
      firstName: _firstNameTextEditingController.text,
      lastName: _lastNameTextEditingController.text,
      email: _emailTextEditingController.text,
      phone: _passwordTextEditingController.text,
      password: _passwordTextEditingController.text,
    );
  }

  bool isEmptyUser(User user) {
    // _btnController.start();
    if (user.email.isNotEmpty &&
        user.password.isNotEmpty &&
        user.firstName.isNotEmpty &&
        user.lastName.isNotEmpty &&
        user.phone.isNotEmpty) {
      return false;
    }
    _message
        .showMessage(AppLocalizations.of(context).translate("pleaseEnterInfo"), isError: true);
    _btnController.reset();
    return true;
  }

  void signUp(BuildContext context) async {
    User user = getUser();
    if (isEmptyUser(user)) return;
    bool isSignUp = await _fbAuth.signUp(user);
    if (isSignUp) {
      Navigator.pushNamedAndRemoveUntil(
          context, "/categoriesScreen", (route) => false);
    }
    _btnController.reset();
  }
}
