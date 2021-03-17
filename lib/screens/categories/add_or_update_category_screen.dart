import 'package:flutter/material.dart';
import 'package:notes_app/controllers/firestore_category.dart';
import 'package:notes_app/locale/AppLocalizations.dart';
import 'package:notes_app/models/category.dart';
import 'package:notes_app/utils/app_colors.dart';
import 'package:notes_app/utils/message.dart';
import 'package:notes_app/utils/size_config.dart';
import 'package:notes_app/widgets/note_text_field.dart';
import 'package:notes_app/widgets/note_button.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class AddOrUpdateCategoryScreen extends StatefulWidget {
  String title;
  String subTitle;
  Category category;
  bool isUpdate;

  AddOrUpdateCategoryScreen(
      {this.title, this.subTitle, this.category, this.isUpdate});

  @override
  _AddOrUpdateCategoryScreenState createState() =>
      _AddOrUpdateCategoryScreenState();
}

class _AddOrUpdateCategoryScreenState extends State<AddOrUpdateCategoryScreen> {
  TextEditingController _titleTextEditingController = TextEditingController();
  TextEditingController _descriptionTextEditingController =
      TextEditingController();

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  FSCategory _fsCategory;
  Message _message;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fsCategory = FSCategory(_scaffoldKey, this.context);
    _message = Message(_scaffoldKey);
    setData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _titleTextEditingController.dispose();
    _descriptionTextEditingController.dispose();
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
        body: Padding(
          padding: EdgeInsetsDirectional.only(
            top: SizeConfig.scaleHeight(95),
            start: SizeConfig.scaleWidth(25),
            end: SizeConfig.scaleWidth(25),
          ),
          child: Column(
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  color: AppColors.DARK_BLUE_COLOR,
                  fontSize: SizeConfig.scaleTextFont(30),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: SizeConfig.scaleHeight(7),
              ),
              Text(
                widget.subTitle,
                style: TextStyle(
                  color: AppColors.HINT_COLOR,
                  fontSize: SizeConfig.scaleTextFont(18),
                ),
              ),
              SizedBox(
                height: SizeConfig.scaleHeight(44),
              ),
              NoteTextField(
                AppLocalizations.of(context).translate("title"),
                _titleTextEditingController,
              ),
              SizedBox(
                height: SizeConfig.scaleHeight(22),
              ),
              //ONLY 40 CHARACTERS
              NoteTextField(
                AppLocalizations.of(context).translate("shortDescription"),
                _descriptionTextEditingController,
              ),
              SizedBox(
                height: SizeConfig.scaleHeight(35),
              ),
              NoteButton(
                AppLocalizations.of(context).translate("save"),
                btnController: _btnController,
                callBack: () {
                  widget.isUpdate == false ? save() : update();
                },
                height: 53,
                borderRadius: 26.5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Category getCategory() {
    String title = _titleTextEditingController.text;
    String description = _descriptionTextEditingController.text;

    if (title.length > 20 || description.length > 30) {
      //Message ERROR
      _message.showMessage(
          AppLocalizations.of(context).translate("titleOrDescriptionIsLong"),
          isError: true);
      _btnController.reset();
      return null;
    }
    return Category(
      id: widget.isUpdate == true ? widget.category.id : "",
      titleCategory: title,
      description: description,
    );
  }

  void clear() {
    _titleTextEditingController.text = "";
    _descriptionTextEditingController.text = "";
  }

  //Save Category
  void save() async {
    Category category = getCategory();
    if (category == null) return;
    if (category.titleCategory.isNotEmpty && category.description.isNotEmpty) {
      bool status = await _fsCategory.createCategory(category);
      if (status) {
        clear();
      }
    } else {
      //Message ERROR
      _message.showMessage(
          AppLocalizations.of(context).translate("PleaseEnterData"),
          isError: true);
    }
    _btnController.reset();
  }

  void setData() {
    if (widget.category == null) {
      return;
    } else if (widget.category.titleCategory.isNotEmpty &&
        widget.category.description.isNotEmpty &&
        widget.isUpdate) {
      _titleTextEditingController.text = widget.category.titleCategory;
      _descriptionTextEditingController.text = widget.category.description;
    }
  }

//Update Category
  update() async {
    Category category = getCategory();
    if (category == null) return;
    if (category.id.isNotEmpty &&
        category.titleCategory.isNotEmpty &&
        category.description.isNotEmpty) {
      bool status = await _fsCategory.updateCategory(category);
    } else {
      //Message ERROR
      _message.showMessage(
          AppLocalizations.of(context).translate("PleaseEnterData"),
          isError: true);
    }
    _btnController.reset();
  }
}
