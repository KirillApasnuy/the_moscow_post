import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_moscow_post/common/widgets/news/NewsCategorySeparator.dart';
import 'package:the_moscow_post/common/widgets/news/news_card/news_card_horizontal.dart';
import 'package:the_moscow_post/data/controllers/news_controller.dart';
import 'package:the_moscow_post/data/repositories/repository.dart';
import 'package:the_moscow_post/utils/constans/colors.dart';

import '../data/models/news.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  ScrollController scrollController = ScrollController();
  NewsController newsController = NewsController(Repository());
  List<int> rubricIdList = [1, 2, 3, 4, 5, 7, 9];
  List<News> _listNews = [];
  bool isSelectCategory = false;
  int selectRubricId = -1;
  int page = 0;

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
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
  }

  void selectRubric(int rubricId) {
    if (!mounted) return; // Проверьте, находится ли состояние в контексте.
    _listNews.clear();
    newsController.fetchNewsRubricNameList(rubricId).then((listNews) {
      if (!mounted) return; // Еще раз проверяем, чтобы избежать ошибок.
      setState(() {
        _listNews.addAll(listNews);
        isSelectCategory = true;
        selectRubricId = rubricId; // Устанавливаем состояние
      });
    }).catchError((error) {
      print("Error fetching news: $error");
    });
  }

  void allRubric() {
    if (!mounted) return; // Проверьте перед изменением состояния.
    setState(() {
      _listNews.clear();
      isSelectCategory = false;
      selectRubricId = -1;
      page = 0; // Сбрасываем состояние
    });

    Future.wait(rubricIdList.map((rubricId) =>
        newsController.fetchNewsRubricNameList(rubricId).then((listNews) {
          if (!mounted) return; // Проверяем перед обновлением состояния.
          setState(() {
            _listNews.addAll(listNews
                .take(5)); // Также ограничьте количество добавляемых новостей
          });
        })));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: AppColors.primaryBackground,
      child: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  controller: scrollController,
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
                      return AppNewsCardHorizontal(
                        news: news,
                        numberItem: index,
                        listNews: _listNews,
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
                      return AppNewsCardHorizontal(
                        news: news,
                        numberItem: index,
                        listNews: _listNews,
                      );
                    }
                  }))
        ],
      ),
    ));
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (selectRubricId != -1) {
        setState(() {
          print("add more news in rub: $selectRubricId and page: $page");
          page++;
          newsController
              .fetchMoreNewsRubricNameList(selectRubricId, page)
              .then((listNews) {
            _listNews.addAll(listNews);
          });
        });
      }
    }
  }
}
