import 'package:flutter/gestures.dart';
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

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailTextEditingController = TextEditingController();
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
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      onTap: () {
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
              top: SizeConfig.scaleHeight(106),
              start: SizeConfig.scaleWidth(26),
              end: SizeConfig.scaleWidth(26),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).translate("signIn"),
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
                    AppLocalizations.of(context)
                        .translate("loginToStartUsingApp"),
                    style: TextStyle(
                      color: AppColors.DARK_GREY_COLOR,
                      fontSize: SizeConfig.scaleTextFont(18),
                    ),
                  ),
                  Card(
                    elevation: 5,
                    color: Colors.white,
                    margin: EdgeInsetsDirectional.only(
                      top: SizeConfig.scaleHeight(81),
                      bottom: SizeConfig.scaleHeight(30),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(
                        top: SizeConfig.scaleHeight(34),
                        bottom: SizeConfig.scaleHeight(32),
                        start: SizeConfig.scaleWidth(21),
                        end: SizeConfig.scaleWidth(20),
                      ),
                      child: Column(
                        children: [
                          NoteTextField(
                            AppLocalizations.of(context).translate("email"),
                            _emailTextEditingController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(
                            height: SizeConfig.scaleHeight(32),
                          ),
                          NoteTextField(
                            AppLocalizations.of(context).translate("password"),
                            _passwordTextEditingController,
                            obscureText: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  NoteButton(
                    AppLocalizations.of(context).translate("login"),
                    height: 53,
                    borderRadius: 26.5,
                    btnController: _btnController,
                    callBack: () {
                      signIn(context);
                    },
                  ),
                  Container(
                    margin: EdgeInsetsDirectional.only(
                        top: SizeConfig.scaleHeight(12)),
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                        text: AppLocalizations.of(context)
                            .translate("doNotHaveAnAccount"),
                        style: TextStyle(
                          color: AppColors.HINT_COLOR,
                          fontSize: 18,
                        ),
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(context, '/signUpScreen');
                              },
                            text:
                                '   ${AppLocalizations.of(context).translate("signUp")}',
                            style: TextStyle(
                              color: AppColors.DARK_BLUE_COLOR,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  User getUser() {
    return User(
      email: _emailTextEditingController.text,
      password: _passwordTextEditingController.text,
    );
  }

  bool isEmptyUser(User user) {
    _btnController.start();
    if (user.email.isNotEmpty && user.password.isNotEmpty) {
      return false;
    }
    //Message Error
    _message.showMessage(
        AppLocalizations.of(context).translate("pleaseEnterInfo"),
        isError: true);
    _btnController.reset();
    return true;
  }

  void signIn(BuildContext context) async {
    User user = getUser();
    if (isEmptyUser(user)) return;
    bool isLogged = await _fbAuth.signIn(user);
    if (isLogged) {
      Navigator.pushNamedAndRemoveUntil(
          context, "/categoriesScreen", (route) => false);
    }
    _btnController.reset();
  }
}
