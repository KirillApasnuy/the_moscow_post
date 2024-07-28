import "package:firebase_core/firebase_core.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:iconsax/iconsax.dart";
import "package:shrink_sidemenu/shrink_sidemenu.dart";
import "package:the_moscow_post/screens/CategoriesScreen.dart";
import "package:the_moscow_post/screens/HomeScreen.dart";
import "package:the_moscow_post/screens/RadioScreen.dart";
import "package:the_moscow_post/screens/SearchScreen.dart";
import "package:the_moscow_post/screens/side_menu/SideMenuList.dart";
import "package:the_moscow_post/utils/constans/colors.dart";
import "package:the_moscow_post/utils/constans/strings.dart";

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  final GlobalKey<SideMenuState> sideMenuKey = GlobalKey<SideMenuState>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Получено сообщение: ${message.notification?.title} ${message.notification?.body}");

      if (message.notification != null) {
        // Отправка уведомления через Local Notifications
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return SideMenu(
      menu: SideMenuList(menuKey: sideMenuKey,),
      key: sideMenuKey,
      background: AppColors.primary,
      type: SideMenuType.slide,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(82, 82, 82, 1),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.menu,
              size: 35,
              color: AppColors.primary,
            ),
            onPressed: () {
              // controller.selectedIndex.value = 0;
              // viewSideMenu();
            },
          ),
          title: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/world.png"),
                fit: BoxFit.fill,
              ),
            ),
            height: kToolbarHeight,
            width: 335,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      Strings.appBarTitle,
                      style: TextStyle(
                        color: Color.fromRGBO(76, 71, 29, 100.0),
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      Strings.appBarTagline,
                      style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                controller.selectedIndex.value = 1;
              },
              icon: const Icon(Icons.search,
                  size: 35, color: AppColors.secondary),
            ),
          ],
        ),
        bottomNavigationBar: Obx(() => BottomNavigationBar(
                currentIndex: controller.selectedIndex.value,
                onTap: (index) => controller.selectedIndex.value = index,
                backgroundColor: AppColors.primary,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.grey,
                type: BottomNavigationBarType.fixed,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Iconsax.home),
                    label: Strings.navBarMain,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Iconsax.search_normal),
                    label: Strings.navBarSearch,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Iconsax.category_2),
                    label: Strings.navBarCategories,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.radio),
                    label: Strings.navBarRadio,
                  )
                ])),
        body: Obx(() => controller.screens[controller.selectedIndex.value]),
      ),
    );
  }
  void viewSideMenu() {
    if (sideMenuKey.currentState!.isOpened) {
      sideMenuKey.currentState!.closeSideMenu();
    } else {
      sideMenuKey.currentState!.openSideMenu();
    }
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const HomeScreen(),
    const SearchScreen(),
    const CategoriesScreen(),
    const RadioScreen(),
  ];
}
