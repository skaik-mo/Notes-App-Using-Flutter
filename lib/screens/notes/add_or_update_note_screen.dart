import 'package:flutter/material.dart';
import 'package:notes_app/controllers/firestore_note.dart';
import 'package:notes_app/locale/AppLocalizations.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/utils/app_colors.dart';
import 'package:notes_app/utils/message.dart';
import 'package:notes_app/utils/size_config.dart';
import 'package:notes_app/widgets/note_text_field.dart';
import 'package:notes_app/widgets/note_button.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class AddOrUpdateNoteScreen extends StatefulWidget {
  String title;
  String subTitle;
  Note note;
  String categoryId;
  bool isUpdate;

  AddOrUpdateNoteScreen(
      {this.title, this.subTitle, this.note, this.categoryId, this.isUpdate});

  @override
  _AddOrUpdateNoteScreenState createState() => _AddOrUpdateNoteScreenState();
}

class _AddOrUpdateNoteScreenState extends State<AddOrUpdateNoteScreen> {
  TextEditingController _titleTextEditingController = TextEditingController();
  TextEditingController _descriptionTextEditingController =
      TextEditingController();

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  FSNote _fsNote;
  Message _message;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fsNote = FSNote(_scaffoldKey, this.context);
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
                AppLocalizations.of(context).translate("description"),
                _descriptionTextEditingController,
              ),
              SizedBox(
                height: SizeConfig.scaleHeight(35),
              ),
              NoteButton(
                AppLocalizations.of(context).translate("save"),
                btnController: _btnController,
                callBack: () {
                  widget.isUpdate ? update() : save();
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

  Note getNote() {
    String title = _titleTextEditingController.text;
    String description = _descriptionTextEditingController.text;

    if (title.length > 20 || description.length > 200) {
      //Message Error
      _message.showMessage(
          AppLocalizations.of(context).translate("titleOrDescriptionIsLong"),
          isError: true);
      _btnController.reset();
      return null;
    }
    return Note(
      id: widget.isUpdate == true ? widget.note.id : "",
      titleNote: title,
      description: description,
    );
  }

  void clear() {
    _titleTextEditingController.text = "";
    _descriptionTextEditingController.text = "";
  }

  //Save Note
  void save() async {
    Note note = getNote();
    if (note == null) return;
    if (note.titleNote.isNotEmpty && note.description.isNotEmpty) {
      bool status = await _fsNote.createNote(widget.categoryId, note);
      if (status) {
        clear();
      }
    } else {
      //Message Error
      _message.showMessage(
          AppLocalizations.of(context).translate("PleaseEnterData"),
          isError: true);
    }
    _btnController.reset();
  }

  void setData() {
    if (widget.note == null) {
      // print("*********Error************");
      return;
    } else if (widget.note.titleNote.isNotEmpty &&
        widget.note.description.isNotEmpty &&
        widget.isUpdate) {
      _titleTextEditingController.text = widget.note.titleNote;
      _descriptionTextEditingController.text = widget.note.description;
    }
  }

//Update Note
  update() async {
    Note note = getNote();
    if (note == null) return;
    if (note.id.isNotEmpty &&
        note.titleNote.isNotEmpty &&
        note.description.isNotEmpty) {
      bool status = await _fsNote.updateNote(note);
    } else {
      //Message Error
      _message.showMessage(
          AppLocalizations.of(context).translate("PleaseEnterData"),
          isError: true);
    }
    _btnController.reset();
  }
}
