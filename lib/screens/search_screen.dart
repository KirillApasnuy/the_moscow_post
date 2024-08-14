import "dart:ui";

import "package:flutter/material.dart";
import "package:jumping_dot/jumping_dot.dart";
import "package:the_moscow_post/common/widgets/news/news_card/news_card_horizontal.dart";
import "package:the_moscow_post/data/controllers/news_controller.dart";
import "package:the_moscow_post/data/models/news.dart";
import "package:the_moscow_post/data/repositories/repository.dart";
import "package:the_moscow_post/utils/constants/colors.dart";
import "package:the_moscow_post/utils/constants/strings.dart";

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final NewsController newsController = NewsController(Repository());
  List<News> _listNews = [];
  final _textController = TextEditingController();
  bool isLoading = false;
  int page = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: window.physicalSize.height,
          width: window.physicalSize.width,
          color: AppColors.primaryBackground,
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: window.physicalSize.width * 0.282,
                        child: TextField(
                          controller: _textController,
                          onSubmitted: (text) {
                            addNewsSearchList(_textController.text);
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            hintText: Strings.hintSearch,
                            focusColor: AppColors.primary,
                            hoverColor: AppColors.primary,
                            hintStyle: const TextStyle(
                              fontSize: 15,
                              fontFamily: "montserrat",
                              fontWeight: FontWeight.w700,
                            ),
                            border: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColors.primary)),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _textController.clear();
                              },
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            addNewsSearchList(_textController.text);
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.search,
                            size: 35,
                          ))
                    ],
                  )),
              isLoading
                  ? const Column(
                      children: [
                        SizedBox(
                          height: 200,
                        ),
                        Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        )
                      ],
                    )
                  : _listNews.isEmpty
                      ? Container(
                          padding: EdgeInsets.only(top: 100),
                          child: Text(
                            textAlign: TextAlign.center,
                            "Введите текст для поиска",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontFamily: "montserrat",
                                fontSize: 30),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            controller: widget.scrollController,
                            itemCount: _listNews.length,
                            itemBuilder: (context, index) {
                              News news = _listNews[index];
                              return index == _listNews.length - 1
                                  ? Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: JumpingDots(
                                        color: AppColors.primary,
                                        radius: 7,
                                        numberOfDots: 3,
                                        animationDuration:
                                            const Duration(milliseconds: 220),
                                        verticalOffset: -4,
                                      ),
                                    )
                                  : NewsCardHorizontal(
                                      news: news,
                                      numberItem: index,
                                      listNews: _listNews,
                                    );
                            },
                          ),
                        ),
            ],
          )),
    );
  }

  void addNewsSearchList(String search) {
    isLoading = true;
    setState(() {
      // Устанавливаем флаг загрузки
    });

    newsController.fetchNewsSearchList(search).then((listNews) {
      setState(() {
        _listNews.clear();
        _listNews.addAll(listNews);
        isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      print("Ошибка получения новостей: $error");
    });
  }

  void _scrollListener() {
    if (widget.scrollController.position.pixels >=
        widget.scrollController.position.maxScrollExtent - 200) {
      setState(() {
        page++;
        newsController
            .fetchMoreNewsSearchList(_textController.text, page)
            .then((listNews) {
          setState(() {
            _listNews.addAll(listNews);
            Set<News> uniqueNews = _listNews.toSet();
            _listNews = uniqueNews.toList();
          });
        });
      });
    }
  }
}
