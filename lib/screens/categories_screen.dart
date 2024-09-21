import "dart:ui";

import "package:flutter/material.dart";
import "package:jumping_dot/jumping_dot.dart";
import "package:the_moscow_post/common/widgets/news/NewsCategorySeparator.dart";
import "package:the_moscow_post/common/widgets/news/news_card/news_card_horizontal.dart";
import "package:the_moscow_post/data/controllers/news_controller.dart";
import "package:the_moscow_post/data/models/news.dart";
import "package:the_moscow_post/data/repositories/repository.dart";
import "package:the_moscow_post/utils/constants/colors.dart";

class CategoriesScreen extends StatefulWidget {
  final ScrollController scrollController;

  const CategoriesScreen({super.key, required this.scrollController});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  NewsController newsController = NewsController(Repository());
  List<int> rubricIdList = [1, 2, 3, 4, 5, 7];
  List<News> _listNews = [];
  bool isSelectCategory = false;
  int selectRubricId = -1;
  int page = 0;
  bool isLoading = true;
  bool isFail = false;
  int countHandleBackBtn = 0;

  @override
  void initState() {
    super.initState();
    allRubric();
    countHandleBackBtn = 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void selectRubric(int rubricId) {
    countHandleBackBtn--;
    isLoading = true;
    setState(() {});
    if (!mounted) return;
    _listNews.clear();
    newsController.fetchNewsRubricNameList(rubricId).then((listNews) {
      if (!mounted) return;
      setState(() {
        _listNews.addAll(listNews);
        isSelectCategory = true;
        selectRubricId = rubricId;
        widget.scrollController.animateTo(
          0.0,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
        isLoading = false;
      });
    }).catchError((error) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        isFail = true;
      });
    });
  }

  void allRubric() async {
    _listNews.clear();
    setState(() {
      isLoading = true;
      isFail = false;
      isSelectCategory = false;
      selectRubricId = -1;
      page = 0;
    });

    try {
      List<Future<List<News>>> futures = rubricIdList.map((rubricId) {
        return newsController.fetchNewsRubricNameList(rubricId);
      }).toList();

      List<List<News>> results = await Future.wait(futures);

      if (!mounted) return;

      setState(() {
        _listNews.clear();
        for (var newsList in results) {
          for (var newsItem in newsList.take(5)) {
            if (!_listNews.contains(newsItem)) {
              _listNews.add(newsItem);
            }
          }
        }
        isLoading = false;
      });
    } catch (ex) {
      if (!mounted) return;
      print("error: $ex");
      setState(() {
        isLoading = false;
        isFail = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        countHandleBackBtn++;
        if (countHandleBackBtn == 2) {
          return true;
        }
        allRubric();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Container(
              height: 90,
              decoration: const BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Для выхода из приложения, нажимите кнопку \"назад\" ещё раз.",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "montserrat",
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  )
                ],
              ),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        );
        return false;
      },
      child: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          allRubric();
          await Future.delayed(const Duration(seconds: 2));
        },
        child: Scaffold(
          body: Container(
            color: AppColors.primaryBackground,
            width: window.physicalSize.width,
            child: isLoading
                ? const Column(
                    children: [
                      SizedBox(height: 200),
                      CircularProgressIndicator(color: AppColors.primary),
                    ],
                  )
                : isFail
                    ? Center(
                        child: ListView(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 200),
                                const Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    "Произошла ошибка, проверьте подключение к интернету.",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "montserrat",
                                      color: AppColors.primary,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                JumpingDots(
                                  color: AppColors.primary,
                                  radius: 7,
                                  numberOfDots: 3,
                                  animationDuration:
                                      const Duration(milliseconds: 220),
                                  verticalOffset: -4,
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              controller: widget.scrollController,
                              itemCount: _listNews.length,
                              itemBuilder: (context, index) {
                                News news = _listNews[index];
                                if (isSelectCategory) {
                                  if (index == 0) {
                                    return NewsCategorySeparator(
                                      title: news.rubricName,
                                      function: allRubric,
                                    );
                                  }
                                  return Column(
                                    children: [
                                      NewsCardHorizontal(
                                        news: news,
                                        numberItem: index,
                                        listNews: _listNews,
                                      ),
                                      index == _listNews.length - 1
                                          ? JumpingDots(
                                              color: AppColors.primary,
                                              radius: 7,
                                              numberOfDots: 3,
                                              animationDuration: const Duration(
                                                  milliseconds: 220),
                                              verticalOffset: -4,
                                            )
                                          : Container(),
                                    ],
                                  );
                                } else {
                                  if (index % 5 == 0 || index == 0) {
                                    return NewsCategorySeparator(
                                      function: () {
                                        selectRubric(news.rubricId);
                                      },
                                      title: news.rubricName,
                                    );
                                  }
                                  return NewsCardHorizontal(
                                    news: news,
                                    numberItem: index,
                                    listNews: _listNews,
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
          ),
        ),
      ),
    );
  }

  void _scrollListener() {
    if (widget.scrollController.position.pixels >=
        widget.scrollController.position.maxScrollExtent - 200) {
      setState(() {
        if (selectRubricId != -1) {
          page++;
          newsController
              .fetchMoreNewsRubricNameList(selectRubricId, page)
              .then((listNews) {
            if (!mounted) return;
            setState(() {
              _listNews.addAll(listNews);
            });
          });
        }
      });
    }
  }
}
