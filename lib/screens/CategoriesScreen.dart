import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:the_moscow_post/common/widgets/news/NewsCategorySeparator.dart';
import 'package:the_moscow_post/common/widgets/news/news_card/news_card_horizontal.dart';
import 'package:the_moscow_post/data/controllers/news_controller.dart';
import 'package:the_moscow_post/data/repositories/repository.dart';
import 'package:the_moscow_post/utils/constans/colors.dart';

import '../data/models/news.dart';

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

  @override
  void initState() {
    // TODO: implement initState
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
    super.dispose();
    widget.scrollController.removeListener(_scrollListener);
  }

  void selectRubric(int rubricId) {
    isLoading = true;
    setState(() {

    });
    if (!mounted) return; // Проверьте, находится ли состояние в контексте.
    _listNews.clear();
    newsController.fetchNewsRubricNameList(rubricId).then((listNews) {
      if (!mounted) return; // Еще раз проверяем, чтобы избежать ошибок.
      setState(() {
        _listNews.addAll(listNews);
        isSelectCategory = true;
        selectRubricId = rubricId;
        widget.scrollController.animateTo(
          0.0,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );// Устанавливаем состояние
      });
      isLoading = false;
      setState(() {
      });
    }).catchError((error) {
      isLoading = false;
      isFail = true;
      setState(() {});
    });
  }

  void allRubric() {
    isLoading = true;
    isFail = false;
    if (!mounted) return; // Проверка перед изменением состояния
    setState(() {
      _listNews.clear();
      isSelectCategory = false;
      selectRubricId = -1;
      page = 0; // Сброс состояния
    });

    Future.wait(rubricIdList.map((rubricId) =>
        newsController.fetchNewsRubricNameList(rubricId).then((listNews) {
          if (!mounted) return; // Проверка перед изменением состояния
          isLoading = false;
          setState(() {
            listNews.take(5).forEach((newsItem) {
              if (!_listNews.contains(newsItem)) {
                _listNews.add(newsItem); // Добавление только уникальных новостей
              }
            });
          });
        }).catchError((ex) {
          if (!mounted) return; // Проверка перед изменением состояния
          isLoading = false;
          isFail = true;
          setState(() {});
        })));
  }
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          // initState();
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
                    SizedBox(
                      height: 200,
                    ),
                    CircularProgressIndicator(
                      color: AppColors.primary,
                    )
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
                                      const Duration(milliseconds: 220),
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
                                  News news = _listNews[index];
                                  if (isSelectCategory) {
                                    if (index == 0) {
                                      return NewsCategorySeparator(
                                          title: news.rubricName,
                                          function: () {
                                            allRubric();
                                          });
                                    }
                                    return Column(
                                      children: [
                                        AppNewsCardHorizontal(
                                          news: news,
                                          numberItem: index,
                                          listNews: _listNews,
                                        ),
                                        index == _listNews.length - 1
                                            ? JumpingDots(
                                          color: AppColors.primary,
                                          radius: 7,
                                          numberOfDots: 3,
                                          animationDuration:
                                          const Duration(milliseconds: 220),
                                          verticalOffset: -4,
                                        ): Stack(),
                                      ],
                                    );
                                  } else {
                                    if (index == 0) {
                                      return NewsCategorySeparator(
                                        function: () {
                                          selectRubric(news.rubricId);
                                        },
                                        title: news.rubricName,
                                      );
                                    } else if (index == 5) {
                                      return NewsCategorySeparator(
                                        function: () {
                                          selectRubric(news.rubricId);
                                        },
                                        title: news.rubricName,
                                      );
                                    } else if (index == 10) {
                                      return NewsCategorySeparator(
                                        function: () {
                                          selectRubric(news.rubricId);
                                        },
                                        title: news.rubricName,
                                      );
                                    } else if (index == 15) {
                                      return NewsCategorySeparator(
                                        function: () {
                                          selectRubric(news.rubricId);
                                        },
                                        title: news.rubricName,
                                      );
                                    } else if (index == 20) {
                                      return NewsCategorySeparator(
                                        function: () {
                                          selectRubric(news.rubricId);
                                        },
                                        title: news.rubricName,
                                      );
                                    } else if (index == 25) {
                                      return NewsCategorySeparator(
                                        function: () {
                                          selectRubric(news.rubricId);
                                        },
                                        title: news.rubricName,
                                      );
                                    }
                                    // print(news.rubricName);
                                    return
                                      AppNewsCardHorizontal(
                                      news: news,
                                      numberItem: index,
                                      listNews: _listNews,

                                    );
                                  }
                                }))
                      ],
                    ),
        )));
  }

  void _scrollListener() {
    if (widget.scrollController.position.pixels >=
        widget.scrollController.position.maxScrollExtent - 200) {
      setState(() {
        if (selectRubricId != -1) {
          print("add more news in rub: $selectRubricId and page: $page");
          page++;
          newsController
              .fetchMoreNewsRubricNameList(selectRubricId, page)
              .then((listNews) {
            _listNews.addAll(listNews);
            setState(() {});
          });
        }
      });
    }
  }
}
