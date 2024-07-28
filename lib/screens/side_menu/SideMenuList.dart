import 'package:flutter/material.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:the_moscow_post/utils/constans/colors.dart';

class SideMenuList extends StatelessWidget {
  final GlobalKey<SideMenuState> menuKey;
  const SideMenuList({super.key, required this.menuKey} );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: () {
                viewSideBar();
              }, child: Text("Политика"), style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.black,
                  elevation: 3,
                  textStyle: const TextStyle(
                      fontSize: 17,
                      fontFamily: "montserrat",
                      fontWeight: FontWeight.w600)),) ,
              ElevatedButton(onPressed: () {
                viewSideBar();
              }, child: Text("В мире")),
              ElevatedButton(onPressed: () {
                viewSideBar();
              }, child: Text("Экономика")),
              ElevatedButton(onPressed: () {
                viewSideBar();
              }, child: Text("Спорт")),
              ElevatedButton(onPressed: () {
                viewSideBar();
              }, child: Text("Общество")),
            ],
          )
      ),
    );
  }
  void viewSideBar() {
    if (menuKey.currentState!.isOpened) {
      menuKey.currentState!.closeSideMenu();
    } else {
      menuKey.currentState!.openSideMenu();
    }
  }
}
