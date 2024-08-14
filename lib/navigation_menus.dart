import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:iconsax/iconsax.dart";
import "package:onesignal_flutter/onesignal_flutter.dart";
import "package:shrink_sidemenu/shrink_sidemenu.dart";
import "package:the_moscow_post/data/controllers/news_controller.dart";
import "package:the_moscow_post/data/repositories/repository.dart";
import "package:the_moscow_post/screens/categories_screen.dart";
import "package:the_moscow_post/screens/details/news_details_push.dart";
import "package:the_moscow_post/screens/home_screen.dart";
import "package:the_moscow_post/screens/radio_screen.dart";
import "package:the_moscow_post/screens/search_screen.dart";
import "package:the_moscow_post/screens/side_menu/side_menu_list.dart";
import "package:the_moscow_post/utils/constants/colors.dart";
import "package:the_moscow_post/utils/constants/strings.dart";

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  final GlobalKey<SideMenuState> sideMenuKey = GlobalKey<SideMenuState>();
  final NavigationController controller = Get.put(NavigationController());
  NewsController newsController = NewsController(Repository());
  bool topMenuOn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setStateTopMenu();
  }

  void openAppPush(OSNotificationClickEvent event) {
    if (event.notification.title != null) {
      String? newsId = event.notification.additionalData?["newsId"];
      print(newsId);
      if (newsId != null) {
        newsController.fetchNewsId(newsId).then((news) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return NewsDetailsPush(news: news);
          }));
        }).catchError((err) {
          print("error: $err");
          _showErrorSnackBar("Возникла ошибка при загрузке");
        });
      } else {
        _showErrorSnackBar("ID новости отсутствует");
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          height: 90,
          decoration: const BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Center(
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontFamily: "montserrat",
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  void setStateTopMenu() {
    newsController.fetchNewsList().then((listNews) {
      topMenuOn = listNews[0].topMenuOn;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    OneSignal.Notifications.requestPermission(true);
    OneSignal.Notifications.addClickListener((result) {
      openAppPush(result);
    });
    return SideMenu(
      menu: SideMenuList(
        menuKey: sideMenuKey,
      ),
      key: sideMenuKey,
      background: AppColors.primary,
      type: SideMenuType.slide,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(82, 82, 82, 1),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.menu,
              size: 35,
              color: topMenuOn ? AppColors.accent : AppColors.primary,
            ),
            onPressed: () {
              // controller.selectedIndex.value = 0;
              if (topMenuOn) viewSideMenu();
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
                // controller.selectedIndex.value = 1;
              },
              icon:
                  const Icon(Icons.search, size: 35, color: AppColors.primary),
            ),
          ],
        ),
        bottomNavigationBar: Obx(() => BottomNavigationBar(
                currentIndex: controller.selectedIndex.value,
                onTap: (index) {
                  if (index == 0 && controller.selectedIndex.value == 0) {
                    // Прокручиваем вверх, если мы на главной странице
                    controller.homeScrollController.animateTo(
                      0.0,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    // Переключаемся на выбранный экран
                    controller.selectedIndex.value = index;
                  }
                  if (index == 1 && controller.selectedIndex.value == 1) {
                    // Прокручиваем вверх, если мы на главной странице
                    controller.searchScrollController.animateTo(
                      0.0,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    // Переключаемся на выбранный экран
                    controller.selectedIndex.value = index;
                  }

                  if (index == 2 && controller.selectedIndex.value == 2) {
                    // Прокручиваем вверх, если мы на главной странице
                    controller.categoriesScrollController.animateTo(
                      0.0,
                      duration: Duration(seconds: 1),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    // Переключаемся на выбранный экран
                    controller.selectedIndex.value = index;
                  }
                },
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

  final ScrollController homeScrollController = ScrollController();
  final ScrollController categoriesScrollController = ScrollController();
  final ScrollController searchScrollController = ScrollController();
  late final List<Widget> screens;

  NavigationController() {
    screens = [
      HomeScreen(scrollController: homeScrollController),
      SearchScreen(scrollController: searchScrollController),
      CategoriesScreen(scrollController: categoriesScrollController),
      const RadioScreen(),
    ];
  }
}
