import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/controllers/firestore_category.dart';
import 'package:notes_app/locale/AppLocalizations.dart';
import 'package:notes_app/models/category.dart';
import 'package:notes_app/screens/categories/add_or_update_category_screen.dart';
import 'package:notes_app/screens/notes/notes_screen.dart';
import 'package:notes_app/utils/app_colors.dart';
import 'package:notes_app/utils/loading_effect.dart';
import 'package:notes_app/utils/size_config.dart';
import 'package:notes_app/widgets/note_circle.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  FSCategory _fsCategory;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<DocumentSnapshot> categories;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fsCategory = FSCategory(_scaffoldKey, this.context);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate("categories"),
          style: TextStyle(color: AppColors.APP_BAR_COLOR),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/settingsScreen");
            },
            padding: EdgeInsetsDirectional.only(end: SizeConfig.scaleWidth(10)),
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _fsCategory.getCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingEffect(),
              // child: CircularProgressIndicator(
              //   valueColor: AlwaysStoppedAnimation<Color>(AppColors.BLUE_COLOR),
              // ),
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
              categories = snapshot.data;
              if (categories.length == 0) {
                return Center(
                    child: Text(
                  AppLocalizations.of(context)
                      .translate("thereAreNoCategories"),
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
                    bottom: SizeConfig.scaleHeight(10),
                    start: SizeConfig.scaleWidth(18),
                    end: SizeConfig.scaleWidth(17),
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        goToNotesScreen(categories[index].data["titleCategory"],
                            categories[index].documentID);
                        // print('go to notes screen');
                      },
                      child: Container(
                        margin: EdgeInsetsDirectional.only(
                          bottom: SizeConfig.scaleHeight(15),
                        ),
                        height: SizeConfig.scaleWidth(70),
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
                            NoteCircle(
                              radius: 24,
                              text: categories[index]
                                  .data["titleCategory"]
                                  .toString()
                                  .substring(0, 1)
                                  .toUpperCase(),
                              topMargin: 10,
                              bottomMargin: 10,
                              startMargin: 15,
                              endMargin: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  categories[index].data["titleCategory"],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: SizeConfig.scaleTextFont(13),
                                  ),
                                ),
                                SizedBox(
                                  height: SizeConfig.scaleHeight(1),
                                ),
                                Text(
                                  // ONLY 40 CHARACTERS
                                  categories[index].data["description"],
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: AppColors.LIGHT_GREY_COLOR,
                                    fontWeight: FontWeight.w700,
                                    fontSize: SizeConfig.scaleTextFont(12),
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            IconButton(
                              onPressed: () {
                                deleteCategory(categories[index]);
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Color(0xffD84040),
                              ),
                            ),
                            Container(
                              height: double.infinity,
                              width: SizeConfig.scaleWidth(20),
                              decoration: BoxDecoration(
                                color: AppColors.BLUE_COLOR,
                                borderRadius: BorderRadiusDirectional.only(
                                  topEnd: Radius.circular(5),
                                  bottomEnd: Radius.circular(5),
                                ),
                              ),
                              child: IconButton(
                                padding: EdgeInsetsDirectional.zero,
                                onPressed: () {
                                  addOrUpdateCategory(
                                    AppLocalizations.of(context)
                                        .translate("category"),
                                    AppLocalizations.of(context)
                                        .translate("updateCategory"),
                                    document: categories[index],
                                    isUpdate: true,
                                  );
                                },
                                iconSize: SizeConfig.scaleWidth(16),
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.BLUE_COLOR,
        child: Icon(Icons.add),
        elevation: 5,
        onPressed: () {
          addOrUpdateCategory(
            AppLocalizations.of(context).translate("newCategory"),
            AppLocalizations.of(context).translate("createCategory"),
          );
        },
      ),
    );
  }

  void addOrUpdateCategory(String title, String subTitle,
      {DocumentSnapshot document, bool isUpdate = false}) {
    Category category;
    if (isUpdate) {
      category = Category(
        id: document.documentID,
        titleCategory: document.data["titleCategory"],
        description: document.data["description"],
      );
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddOrUpdateCategoryScreen(
          title: title,
          subTitle: subTitle,
          category: category,
          isUpdate: isUpdate,
        ),
      ),
    ).then((value) {
      setState(() {});
    });
  }

  void goToNotesScreen(String title, String categoryId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NotesScreen(
                  titleAppBar: title,
                  categoryId: categoryId,
                )));
  }

  void deleteCategory(DocumentSnapshot document) async {
    Category category = Category(
      id: document.documentID,
      titleCategory: document.data["titleCategory"],
      description: document.data["description"],
    );
    bool status = await _fsCategory.deleteCategory(category);
    if (status) {
      setState(() {});
    }
  }
}
