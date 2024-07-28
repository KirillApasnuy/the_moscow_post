import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:the_moscow_post/data/controllers/news_controller.dart';
import 'package:the_moscow_post/data/repositories/repository.dart';
import 'package:the_moscow_post/utils/constans/colors.dart';

import '../common/widgets/news/news_card/news_card_horizontal.dart';
import '../data/models/news.dart';
import '../utils/constans/strings.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final NewsController newsController = NewsController(Repository());
  List<News> _listNews = [];
  final _textController = TextEditingController();
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                          },
                          icon: const Icon(
                            Icons.search,
                            size: 35,
                          ))
                    ],
                  )),
              _listNews.isEmpty
                  ? Container(
                      padding: EdgeInsets.only(top: 100),
                      child: Text(
                        "Нет новостей",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: "montserrat",
                            fontSize: 30),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: _listNews.length,
                        itemBuilder: (context, index) {
                          News news = _listNews[index];
                          return AppNewsCardHorizontal(
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
    setState(() {
      isLoading = true; // Устанавливаем флаг загрузки
    });

    newsController.fetchNewsSearchList(search).then((listNews) {
      setState(() {
        _listNews.clear();
        _listNews.addAll(listNews);
        isLoading = false; // Обнуляем флаг загрузки после получения данных
      });
    }).catchError((error) {
      setState(() {
        isLoading = false; // Убедитесь, что флаг сбрасывается и в случае ошибки
      });
      print("Ошибка получения новостей: $error");
    });
  }

}
