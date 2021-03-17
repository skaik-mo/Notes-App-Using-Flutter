import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/controllers/firestore_note.dart';
import 'package:notes_app/locale/AppLocalizations.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/screens/notes/add_or_update_note_screen.dart';
import 'package:notes_app/utils/app_colors.dart';
import 'package:notes_app/utils/size_config.dart';

class NotesScreen extends StatefulWidget {
  String titleAppBar;
  String categoryId;

  NotesScreen({this.titleAppBar, this.categoryId});

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  Color checkColor = AppColors.Very_LIGHT_GREY_COLOR;

  FSNote _fsNote;
  List<DocumentSnapshot> notes = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fsNote = FSNote(_scaffoldKey, this.context);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key:  UniqueKey(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.titleAppBar,
          style: TextStyle(
            color: AppColors.APP_BAR_COLOR,
            fontSize: SizeConfig.scaleTextFont(22),
            fontWeight: FontWeight.bold,
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
        actions: [
          IconButton(
            onPressed: () {
              //add note
              addOrUpdateNote(AppLocalizations.of(context).translate("newNote"),
                  AppLocalizations.of(context).translate("createNote"));
            },
            padding: EdgeInsetsDirectional.only(end: SizeConfig.scaleWidth(10)),
            icon: Icon(Icons.add_circle),
            color: Colors.black,
          ),
        ],
      ),
      body: FutureBuilder(
        future: _fsNote.getNotes(widget.categoryId),
        builder: (context, snapshot) {
          var state = notes == snapshot.data
              ? ConnectionState.done
              : ConnectionState.waiting;
          if (snapshot.connectionState == state) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.BLUE_COLOR),
              ),
            );
          } else {
            if (snapshot.hasError) {
              return Center(
                  child: Text(
                AppLocalizations.of(context).translate("error"),
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ));
            } else {
              notes = snapshot.data;
              if (notes.length == 0) {
                return Center(
                    child: Text(
                  AppLocalizations.of(context).translate("thereAreNoNotes"),
                  style: TextStyle(
                    color: AppColors.BLUE_COLOR,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ));
              } else {
                return ListView.builder(
                  padding: EdgeInsetsDirectional.only(
                    top: SizeConfig.scaleHeight(25),
                    bottom: SizeConfig.scaleHeight(25),
                  ),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    checkColor = waitingOrNot(index);
                    return Dismissible(
                      key: Key(notes[index].toString()),
                      direction: DismissDirection.endToStart,
                      resizeDuration: Duration(seconds: 1),
                      movementDuration: Duration(seconds: 1),
                      background: Container(
                        padding: EdgeInsetsDirectional.only(end: 20),
                        margin: EdgeInsetsDirectional.only(top: 15),
                        width: double.infinity,
                        color: Colors.red,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 30,
                            ),
                          ],
                        ),
                      ),
                      onDismissed: (direction) {
                        // Remove the item from the data source.
                        deleteNote(notes[index], index);
                      },
                      child: GestureDetector(
                        onTap: () {
                          //update note
                          addOrUpdateNote(
                            AppLocalizations.of(context).translate("note"),
                            AppLocalizations.of(context)
                                .translate("updateNote"),
                            document: notes[index],
                            isUpdate: true,
                          );
                        },
                        child: Container(
                          margin: EdgeInsetsDirectional.only(
                            top: SizeConfig.scaleHeight(15),
                            start: SizeConfig.scaleWidth(18),
                            end: SizeConfig.scaleWidth(17),
                          ),
                          height: SizeConfig.scaleWidth(115),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadiusDirectional.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.LIGHT_GREY_COLOR,
                                offset: Offset(0, 0),
                                spreadRadius: 0.2,
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: double.infinity,
                                width: SizeConfig.scaleWidth(4),
                                margin: EdgeInsetsDirectional.only(
                                  end: SizeConfig.scaleWidth(16),
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.BLUE_COLOR,
                                  borderRadius: BorderRadiusDirectional.only(
                                    topStart: Radius.circular(5),
                                    bottomStart: Radius.circular(5),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.only(
                                    top: SizeConfig.scaleHeight(19),
                                    bottom: SizeConfig.scaleHeight(19),
                                    end: SizeConfig.scaleWidth(5),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        notes[index].data["titleNote"],
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize:
                                              SizeConfig.scaleTextFont(13),
                                        ),
                                      ),
                                      SizedBox(
                                        height: SizeConfig.scaleHeight(1),
                                      ),
                                      Text(
                                        notes[index].data["description"],
                                        // " Lorem Lorem Lorem Lorem Lorem Lorem Lorem Lorem " +
                                        //     " Lorem Lorem Lorem Lorem Lorem Lorem Lorem Lorem " +
                                        //     " Lorem Lorem Lorem Lorem Lorem Lorem Lorem Lorem " +
                                        //     " Lorem Lorem Lorem Lorem Lorem Lorem Lorem Lorem ",
                                        maxLines: 4,
                                        style: TextStyle(
                                          color: AppColors.LIGHT_GREY_COLOR,
                                          fontWeight: FontWeight.w700,
                                          fontSize:
                                              SizeConfig.scaleTextFont(12),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Spacer(),
                              IconButton(
                                iconSize: SizeConfig.scaleHeight(25),
                                icon: Icon(
                                  Icons.check_circle,
                                  color: checkColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    chaneStatusNote(notes[index]);
                                  });
                                },
                              ),
                              Container(
                                height: double.infinity,
                                width: SizeConfig.scaleWidth(4),
                                margin: EdgeInsetsDirectional.only(
                                  start: SizeConfig.scaleWidth(10),
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.BLUE_COLOR,
                                  borderRadius: BorderRadiusDirectional.only(
                                    topEnd: Radius.circular(5),
                                    bottomEnd: Radius.circular(5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            }
          }
        },
      ),
    );
  }

  void deleteNote(DocumentSnapshot document, int index) {
    _fsNote.deleteNote(document.documentID);
    notes.removeAt(index);
  }

  Color waitingOrNot(int index) {
    Note note = Note(
      id: notes[index].documentID,
      titleNote: notes[index].data["titleNote"],
      description: notes[index].data["description"],
      status: notes[index].data["status"],
    );
    bool status = note.status;
    return status == true ? Color(0xff98CE63) : AppColors.Very_LIGHT_GREY_COLOR;
  }

  void chaneStatusNote(DocumentSnapshot document) async {
    Note note = Note(
      id: document.documentID,
      titleNote: document.data["titleNote"],
      description: document.data["description"],
      status: !document.data["status"],
    );
    bool status = await _fsNote.updateStatusNote(note);
    if (status) {
      checkColor = checkColor == AppColors.Very_LIGHT_GREY_COLOR
          ? Color(0xff98CE63)
          : AppColors.Very_LIGHT_GREY_COLOR;
    }
  }

  void addOrUpdateNote(String title, String subTitle,
      {DocumentSnapshot document, bool isUpdate = false}) {
    Note note;
    if (isUpdate) {
      note = Note(
        id: document.documentID,
        titleNote: document.data["titleNote"],
        description: document.data["description"],
      );
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddOrUpdateNoteScreen(
          title: title,
          subTitle: subTitle,
          categoryId: widget.categoryId,
          note: note,
          isUpdate: isUpdate,
        ),
      ),
    ).then((value) {
      setState(() {

      });
    });
  }
}
