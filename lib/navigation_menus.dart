import "package:firebase_core/firebase_core.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:get/get.dart";
import "package:iconsax/iconsax.dart";
import "package:shrink_sidemenu/shrink_sidemenu.dart";
import "package:the_moscow_post/data/controllers/news_controller.dart";
import "package:the_moscow_post/data/repositories/repository.dart";
import "package:the_moscow_post/screens/CategoriesScreen.dart";
import "package:the_moscow_post/screens/HomeScreen.dart";
import "package:the_moscow_post/screens/RadioScreen.dart";
import "package:the_moscow_post/screens/SearchScreen.dart";
import "package:the_moscow_post/screens/details/news_details_push.dart";
import "package:the_moscow_post/screens/side_menu/SideMenuList.dart";
import "package:the_moscow_post/utils/constans/colors.dart";
import "package:the_moscow_post/utils/constans/strings.dart";

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Настройка локальных уведомлений
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // name
    importance: Importance.high,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  if (message.notification != null) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'high_importance_channel', // id
      'High Importance Notifications', // name
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      message.notification.hashCode,
      message.notification!.title,
      message.notification!.body,
      platformChannelSpecifics,
    );
  }
}

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});
  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  final GlobalKey<SideMenuState> sideMenuKey = GlobalKey<SideMenuState>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final NavigationController controller = Get.put(NavigationController());
  NewsController newsController = NewsController(Repository());
  bool topMenuOn = false;

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      openAppPush(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(openAppPush);
  }


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
    var _messaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("onMessage: $message");
      // openAppPush(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("OnMessageOpenedApp:    ${message.notification!.title}");
      print("OnMessageOpenedApp: ${message.data["id"]}");
      openAppPush(message);
    });
    _messaging.getInitialMessage().then((RemoteMessage? message){
      if (message != null) {
        _firebaseMessagingBackgroundHandler(message);
      }
    });

    setupInteractedMessage();
    setStateTopMenu();
    setState(() {

    });
  }
  void openAppPush(RemoteMessage message) {
    setState(() {
      if (message.notification?.title != null) {
        newsController
            .fetchNewsId(int.parse(message.data["newsId"]))
            .then((news){
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return NewsDetailsPush(
              news: news,
            );
          }));
        }).catchError((err) {
          print("error: $err");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Container(
                height: 90,
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius:
                    BorderRadius.all(Radius.circular(10))),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Возникла ошибка при загруке",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "montserrat",
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          );
        });
      }
    });
  }

  void setStateTopMenu() {
    newsController.fetchNewsList().then((_listNews) {
      topMenuOn = _listNews[0].topMenuOn;
      setState(() {

      });
    });
  }
  @override
  Widget build(BuildContext context) {
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
              icon: const Icon(Icons.search,
                  size: 35, color: AppColors.primary),
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
