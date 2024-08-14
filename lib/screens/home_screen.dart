import "dart:async";
import "dart:developer";
import "dart:ui";

import "package:flutter/material.dart";
import "package:jumping_dot/jumping_dot.dart";
import "package:shrink_sidemenu/shrink_sidemenu.dart";
import "package:the_moscow_post/common/widgets/news/news_card/first_news_card_horizontal.dart";
import "package:the_moscow_post/common/widgets/news/news_card/news_card_horizontal.dart";
import "package:the_moscow_post/data/controllers/news_controller.dart";
import "package:the_moscow_post/data/controllers/pages_controller.dart";
import "package:the_moscow_post/data/models/news.dart";
import "package:the_moscow_post/data/models/pages.dart";
import "package:the_moscow_post/data/repositories/repository.dart";
import "package:the_moscow_post/screens/details/news_details.dart";
import "package:the_moscow_post/utils/constants/colors.dart";
import "package:the_moscow_post/utils/constants/strings.dart";

class HomeScreen extends StatefulWidget {
  final ScrollController scrollController;

  const HomeScreen({super.key, required this.scrollController});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<SideMenuState> sideMenuKey = GlobalKey<SideMenuState>();
  NewsController newsController = NewsController(Repository());
  PagesController pagesController = PagesController(Repository());
  List<Pages> listPage = [];
  bool isPopularSort = false;
  int page = 0;
  List<News> _listNews = [];
  List<News> _hiddenListNews = [];
  List<int> _filterRubricId = [];
  bool isSport = true;
  bool isPolitics = true;
  bool isInWorld = true;
  bool isCulture = true;
  bool isSocial = true;
  bool isEconomics = true;
  bool isLoading = true;
  bool isFail = false;
  String failMessage = '';

  @override
  void initState() {
    super.initState();
    allRubric();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    widget.scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          setState(() {
            _listNews.clear();
            allRubric();
            isPopularSort = false;
          });

          await Future.delayed(const Duration(seconds: 2));
        },
        child: Scaffold(
          body: Container(
            color: AppColors.secondary,
            height: window.physicalSize.height,
            child: isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                        Text(
                          textAlign: TextAlign.center,
                          "Идёт загрузка",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: "montserrat",
                              color: AppColors.primary,
                              fontSize: 20),
                        ),
                      ],
                    ),
                  )
                : isFail
                    ? Center(
                        child: ListView(
                          children: [
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 200,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      "Произошла ошибка, проверьте подключение к интернету.",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "montserrat",
                                          color: AppColors.primary,
                                          fontSize: 20),
                                    ),
                                  ),
                                  JumpingDots(
                                    color: AppColors.primary,
                                    radius: 7,
                                    numberOfDots: 3,
                                    animationDuration:
                                        Duration(milliseconds: 220),
                                    verticalOffset: -4,
                                  ),
                                ])
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Expanded(
                              child: ListView.builder(
                            controller: widget.scrollController,
                            itemCount: _listNews.length ?? 0,
                            itemBuilder: (context, index) {
                              var news = _listNews[index];
                              return index == 0
                                  ? Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return NewsDetails(
                                                news: news,
                                                numberItem: index,
                                                listNews: _listNews,
                                              );
                                            }));
                                          },
                                          child: FirstNewsCardHorizontal(
                                            title: news.title,
                                            mediumImageTitleUrl:
                                                news.smallImageSrc,
                                          ),
                                        ),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _listNews.clear();
                                                    allRubric();
                                                    isPopularSort = false;
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppColors.primary,
                                                    foregroundColor:
                                                        Colors.white,
                                                    shadowColor: Colors.black,
                                                    elevation: 3,
                                                    textStyle: const TextStyle(
                                                        fontSize: 17,
                                                        fontFamily:
                                                            "montserrat",
                                                        fontWeight:
                                                            FontWeight.w600)),
                                                child: const Text(
                                                    Strings.catBarAllNews),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  sortPopular();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppColors.primary,
                                                    foregroundColor:
                                                        Colors.white,
                                                    shadowColor: Colors.black,
                                                    elevation: 3,
                                                    textStyle: const TextStyle(
                                                        fontSize: 17,
                                                        fontFamily:
                                                            "montserrat",
                                                        fontWeight:
                                                            FontWeight.w600)),
                                                child: const Text(
                                                    Strings.catBarPopular),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  sortPopular();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppColors.primary,
                                                    foregroundColor:
                                                        Colors.white,
                                                    shadowColor: Colors.black,
                                                    elevation: 3,
                                                    textStyle: const TextStyle(
                                                        fontSize: 17,
                                                        fontFamily:
                                                            "montserrat",
                                                        fontWeight:
                                                            FontWeight.w600)),
                                                child: const Text(
                                                    Strings.catBarRead),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              ChoiceChip(
                                                iconTheme: IconThemeData(
                                                    color: Colors.purple),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                label: Text("Спорт",
                                                    style: TextStyle(
                                                        color: isSport
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontSize: 17,
                                                        fontFamily:
                                                            "montserrat",
                                                        fontWeight:
                                                            FontWeight.w600)),
                                                backgroundColor:
                                                    AppColors.secondary,
                                                selected: isSport,
                                                selectedColor:
                                                    AppColors.primary,
                                                onSelected: (newsState) {
                                                  setState(() {
                                                    if (isSport) if (_filterRubricId
                                                            .length >=
                                                        5) return;
                                                    isSport = newsState;
                                                    filterRubrics(isSport, 5);
                                                  });
                                                },
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              ChoiceChip(
                                                iconTheme: IconThemeData(
                                                    color: Colors.purple),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                label: Text("Политика",
                                                    style: TextStyle(
                                                        color: isPolitics
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontSize: 17,
                                                        fontFamily:
                                                            "montserrat",
                                                        fontWeight:
                                                            FontWeight.w600)),
                                                backgroundColor:
                                                    AppColors.secondary,
                                                selected: isPolitics,
                                                selectedColor:
                                                    AppColors.primary,
                                                onSelected: (newsState) {
                                                  setState(() {
                                                    if (isPolitics) if (_filterRubricId
                                                            .length >=
                                                        5) return;
                                                    isPolitics = newsState;

                                                    filterRubrics(
                                                        isPolitics, 1);
                                                  });
                                                },
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              ChoiceChip(
                                                iconTheme: IconThemeData(
                                                    color: Colors.purple),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                label: Text("В мире",
                                                    style: TextStyle(
                                                        color: isInWorld
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontSize: 17,
                                                        fontFamily:
                                                            "montserrat",
                                                        fontWeight:
                                                            FontWeight.w600)),
                                                backgroundColor:
                                                    AppColors.secondary,
                                                selected: isInWorld,
                                                selectedColor:
                                                    AppColors.primary,
                                                onSelected: (newsState) {
                                                  setState(() {
                                                    if (isInWorld) if (_filterRubricId
                                                            .length >=
                                                        5) return;
                                                    isInWorld = newsState;

                                                    filterRubrics(isInWorld, 2);
                                                  });
                                                },
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              ChoiceChip(
                                                iconTheme: IconThemeData(
                                                    color: Colors.purple),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                label: Text("Культура",
                                                    style: TextStyle(
                                                        color: isCulture
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontSize: 17,
                                                        fontFamily:
                                                            "montserrat",
                                                        fontWeight:
                                                            FontWeight.w600)),
                                                backgroundColor:
                                                    AppColors.secondary,
                                                selected: isCulture,
                                                selectedColor:
                                                    AppColors.primary,
                                                onSelected: (newsState) {
                                                  setState(() {
                                                    if (isCulture) if (_filterRubricId
                                                            .length >=
                                                        5) return;
                                                    isCulture = newsState;
                                                    filterRubrics(isCulture, 4);
                                                  });
                                                },
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              ChoiceChip(
                                                iconTheme: IconThemeData(
                                                    color: Colors.purple),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                label: Text("Общество",
                                                    style: TextStyle(
                                                        color: isSocial
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontSize: 17,
                                                        fontFamily:
                                                            "montserrat",
                                                        fontWeight:
                                                            FontWeight.w600)),
                                                backgroundColor:
                                                    AppColors.secondary,
                                                selected: isSocial,
                                                selectedColor:
                                                    AppColors.primary,
                                                onSelected: (newsState) {
                                                  setState(() {
                                                    if (isSocial) if (_filterRubricId
                                                            .length >=
                                                        5) return;
                                                    isSocial = newsState;

                                                    filterRubrics(isSocial, 7);
                                                  });
                                                },
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              ChoiceChip(
                                                iconTheme: IconThemeData(
                                                    color: Colors.purple),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                label: Text("Экономика",
                                                    style: TextStyle(
                                                        color: isEconomics
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontSize: 17,
                                                        fontFamily:
                                                            "montserrat",
                                                        fontWeight:
                                                            FontWeight.w600)),
                                                backgroundColor:
                                                    AppColors.secondary,
                                                selected: isEconomics,
                                                selectedColor:
                                                    AppColors.primary,
                                                onSelected: (newsState) {
                                                  setState(() {
                                                    if (isEconomics) if (_filterRubricId
                                                            .length >=
                                                        5) return;
                                                    isEconomics = newsState;

                                                    filterRubrics(
                                                        isEconomics, 3);
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  : index == _listNews.length - 1
                                      ? Padding(
                                          padding: EdgeInsets.all(5),
                                          child: JumpingDots(
                                            color: AppColors.primary,
                                            radius: 7,
                                            numberOfDots: 3,
                                            animationDuration:
                                                Duration(milliseconds: 220),
                                            verticalOffset: -4,
                                          ),
                                        )
                                      : NewsCardHorizontal(
                                          news: news,
                                          numberItem: index,
                                          listNews: _listNews,
                                        );
                            },
                          )),
                        ],
                      ),
          ),
        ));
  }

  void sortPopular() {
    Set<News> uniqueNews = _listNews.toSet();
    _listNews = uniqueNews.toList();

    setState(() {
      isPopularSort = true;

      if (_listNews.length > 1) {
        News firstElement = _listNews[0];

        List<News> newsToSort = _listNews.sublist(1);
        newsToSort.sort(
            (news1, news2) => news2.viewsCount.compareTo(news1.viewsCount));

        _listNews = [firstElement, ...newsToSort];
      }
    });
  }

  void allRubric() {
    isSport = true;
    isPolitics = true;
    isInWorld = true;
    isCulture = true;
    isSocial = true;
    isEconomics = true;

    newsController.fetchNewsList().then((listNews) {
      _filterRubricId.clear();

      News? firstNews = listNews[0];

      _listNews.addAll(listNews.where((news) => news != firstNews));

      _listNews.insert(0, firstNews);

      setState(() {
        isLoading = false;
        isFail = false;
      });
    }).catchError((err) {
      isLoading = false;
      isFail = true;
      failMessage = "Произошла ошибка: $failMessage}";

      setState(() {});
    });
  }

  void filterRubrics(bool rubric, int? rubricId) {
    News? firstElement = _listNews.isNotEmpty ? _listNews[0] : null;
    Set<News> uniqueNews = _listNews.toSet();
    _listNews = uniqueNews.toList();

    setState(() {
      if (!rubric) {
        if (rubricId != null) {
          _filterRubricId.add(rubricId.toInt());
          _hiddenListNews
              .addAll(_listNews.where((news) => news.rubricId == rubricId));
          _listNews.removeWhere(
              (news) => news.rubricId == rubricId && news != firstElement);
          log("Filter successful");
        }
      } else {
        if (rubricId != null && _filterRubricId.contains(rubricId)) {
          _filterRubricId.remove(rubricId.toInt());
          final newsToAdd =
              _hiddenListNews.where((news) => news.rubricId == rubricId);
          _listNews.addAll(newsToAdd.where((news) => news != firstElement));

          _hiddenListNews.removeWhere((news) => news.rubricId == rubricId);
          log("Add filter successful");
        }
      }
      if (firstElement != null && !_listNews.contains(firstElement)) {
        _listNews.insert(0, firstElement);
      }
    });
  }

  void _scrollListener() {
    if (widget.scrollController.position.pixels >=
        widget.scrollController.position.maxScrollExtent - 200) {
      setState(() {
        page++;
        newsController.fetchMoreNewsList(page).then((listNews) {
          setState(() {
            _listNews.addAll(listNews);
            if (isPopularSort) {
              sortPopular();
            }
            if (_filterRubricId.isNotEmpty) {
              for (int rubric in _filterRubricId) {
                _hiddenListNews
                    .addAll(_listNews.where((news) => news.rubricId == rubric));
                _listNews.removeWhere((news) => news.rubricId == rubric);
              }
              Set<News> uniqueNews = _listNews.toSet();
              _listNews = uniqueNews.toList();
            }
          });
        });
      });
    }
  }

  void checkPageController() {
    pagesController.fetchPageList().then((listPage) {
      listPage.addAll(listPage);
    });
  }
}
