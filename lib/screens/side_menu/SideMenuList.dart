import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:the_moscow_post/controllers/context/context_controller.dart';
import 'package:the_moscow_post/data/controllers/news_controller.dart';
import 'package:the_moscow_post/data/controllers/pages_controller.dart';
import 'package:the_moscow_post/data/models/news.dart';
import 'package:the_moscow_post/data/models/pages.dart';
import 'package:the_moscow_post/data/repositories/repository.dart';
import 'package:the_moscow_post/screens/details/pages_details.dart';
import 'package:the_moscow_post/utils/constans/colors.dart';

class SideMenuList extends StatefulWidget {
  final GlobalKey<SideMenuState> menuKey;

  const SideMenuList({Key? key, required this.menuKey}) : super(key: key);

  @override
  State<SideMenuList> createState() => _SideMenuListState();
}

class _SideMenuListState extends State<SideMenuList> {
  PagesController pagesController = PagesController(Repository());
  List<Pages> listPages = [];

  @override
  void initState() {
    super.initState();
    getAllPages();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ContextController.getHeightScreen(context) + 250,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: listPages.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 25,),
                        GestureDetector(
                          child: Text(
                            listPages[index].title,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 23,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return PagesDetails(pages: listPages[index]);
                            }));
                          },
                        ),
                      ],
                    ),
                    Container(
                      height: 1,
                      width: ContextController.getWidthScreen(context) * 0.6,
                      color: AppColors.secondary,
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void getAllPages() {
    pagesController.fetchPageList().then((_listPages) {
      if (_listPages.isNotEmpty) {
        listPages.addAll(_listPages);
        setState(() {});
      }
    }).catchError((error) {
      print("Error fetching pages: $error");
    });
  }

  void viewSideBar() {
    if (widget.menuKey.currentState!.isOpened) {
      widget.menuKey.currentState!.closeSideMenu();
    } else {
      widget.menuKey.currentState!.openSideMenu();
    }
  }
}
