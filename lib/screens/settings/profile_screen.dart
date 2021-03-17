import 'package:flutter/material.dart';
import 'package:notes_app/controllers/firebase_auth.dart';
import 'package:notes_app/controllers/firestore_category.dart';
import 'package:notes_app/controllers/user_preferences.dart';
import 'package:notes_app/locale/AppLocalizations.dart';
import 'package:notes_app/models/category.dart';
import 'package:notes_app/models/user.dart';
import 'package:notes_app/utils/app_colors.dart';
import 'package:notes_app/utils/message.dart';
import 'package:notes_app/utils/size_config.dart';
import 'package:notes_app/widgets/counter_widget.dart';
import 'package:notes_app/widgets/note_circle.dart';
import 'package:notes_app/widgets/note_text_field.dart';
import 'package:notes_app/widgets/note_button.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _firstNameTextEditingController =
      TextEditingController();
  TextEditingController _lastNameTextEditingController =
      TextEditingController();
  TextEditingController _emailTextEditingController = TextEditingController();
  TextEditingController _phoneTextEditingController = TextEditingController();

  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  FBAuth _fbAuth;
  Message _message;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  User _user;
  String userName = "";
  String emailUser = "";
  String firstChar = "";

  String numberOfCategories = "";
  String numberOfDoneNotes = "";
  String numberOfWaitingNotes = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialize();
  }

  void initialize() {
    _fbAuth = FBAuth(_scaffoldKey, this.context);
    _message = Message(_scaffoldKey);
    showData();
    showInfo();
    numberOfData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _firstNameTextEditingController.dispose();
    _lastNameTextEditingController.dispose();
    _emailTextEditingController.dispose();
    _phoneTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).translate("profile"),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.APP_BAR_COLOR,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: SizeConfig.scaleWidth(20),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: ListView(
          padding: EdgeInsetsDirectional.only(
            start: SizeConfig.scaleWidth(25),
            end: SizeConfig.scaleWidth(25),
          ),
          children: [
            Container(
              margin: EdgeInsetsDirectional.only(
                top: SizeConfig.scaleHeight(31),
                bottom: SizeConfig.scaleHeight(15),
              ),
              height: SizeConfig.scaleWidth(65),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadiusDirectional.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.Very_LIGHT_GREY_COLOR,
                    offset: Offset(0, 3),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  NoteCircle(
                    radius: 27.5,
                    text: firstChar,
                    isShadow: true,
                    startMargin: SizeConfig.scaleWidth(15),
                    endMargin: SizeConfig.scaleWidth(15),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: SizeConfig.scaleTextFont(13),
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.scaleWidth(3),
                      ),
                      Text(
                        emailUser,
                        style: TextStyle(
                          fontSize: SizeConfig.scaleTextFont(12),
                          fontWeight: FontWeight.w600,
                          color: AppColors.LIGHT_GREY_COLOR,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CounterItem(
                    AppLocalizations.of(context).translate("categories"),
                    numberOfCategories,
                    // marginEnd: 17.5,
                  ),
                ),
                SizedBox(
                  width: SizeConfig.scaleWidth(35),
                ),
                Expanded(
                  flex: 1,
                  child: CounterItem(
                    AppLocalizations.of(context).translate("doneNotes"),
                    numberOfDoneNotes,
                    // marginStart: 17.5,
                    // marginEnd: 17.5,
                  ),
                ),
                SizedBox(
                  width: SizeConfig.scaleWidth(35),
                ),
                Expanded(
                  flex: 1,
                  child: CounterItem(
                    AppLocalizations.of(context).translate("waitingNotes"),
                    numberOfWaitingNotes,
                    // marginStart: 17.5,
                  ),
                ),
              ],
            ),
            Card(
              margin: EdgeInsetsDirectional.only(
                top: SizeConfig.scaleHeight(15),
                bottom: SizeConfig.scaleHeight(15),
              ),
              color: Colors.white,
              elevation: 4,
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(5),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  top: SizeConfig.scaleHeight(22),
                  bottom: SizeConfig.scaleHeight(18),
                  start: SizeConfig.scaleWidth(20),
                  end: SizeConfig.scaleWidth(20),
                ),
                child: Column(
                  children: [
                    NoteTextField(
                      AppLocalizations.of(context).translate("firstName"),
                      _firstNameTextEditingController,
                    ),
                    SizedBox(
                      height: SizeConfig.scaleHeight(20),
                    ),
                    NoteTextField(
                      AppLocalizations.of(context).translate("lastName"),
                      _lastNameTextEditingController,
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
                      AppLocalizations.of(context).translate("email"),
                      _emailTextEditingController,
                    ),
                  ],
                ),
              ),
            ),
            NoteButton(
              AppLocalizations.of(context).translate("save"),
              btnController: _btnController,
              callBack: () {
                editUser();
              },
              height: 46,
              borderRadius: 10,
            ),
          ],
        ),
      ),
    );
  }

  void showData() {
    _user = UserPreferences.instance.getUser();
    _firstNameTextEditingController.text = _user.firstName;
    _lastNameTextEditingController.text = _user.lastName;
    _emailTextEditingController.text = _user.email;
    _phoneTextEditingController.text = _user.phone;
  }

  void showInfo(){
    _user = UserPreferences.instance.getUser();
    userName = "${_user.firstName} ${_user.lastName}";
    emailUser = "${_user.email}";
    firstChar = "${_user.firstName.substring(0, 1).toUpperCase()}";
  }

  void numberOfData() {
    numberOfCategories = UserPreferences.instance.getNumberOfCategories();
    numberOfDoneNotes = UserPreferences.instance.getNumberOfDoneNotes();
    numberOfWaitingNotes = UserPreferences.instance.getNumberOfWaitingNotes();
  }

  User getUser() {
    return User(
      firstName: _firstNameTextEditingController.text,
      lastName: _lastNameTextEditingController.text,
      email: _emailTextEditingController.text,
      phone: _phoneTextEditingController.text,
    );
  }

  bool isEmptyUser(User user) {
    if (user.email.isNotEmpty &&
        user.firstName.isNotEmpty &&
        user.lastName.isNotEmpty &&
        user.phone.isNotEmpty) {
      return false;
    }
    //Message Error
    _message.showMessage(
        AppLocalizations.of(context).translate("pleaseEnterInfo"),
        isError: true);
    _btnController.reset();
    return true;
  }

  void editUser() async {
    User newUser = getUser();
    if (isEmptyUser(newUser)) return;
    bool status = await _fbAuth.editUser(newUser);
    if (status) {
      setState(() {
        showInfo();
      });
    }
    _btnController.reset();
  }
}
