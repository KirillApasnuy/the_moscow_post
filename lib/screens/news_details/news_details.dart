import 'dart:developer';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';
import 'package:the_moscow_post/common/widgets/news/news_card/news_card_horizontal.dart';
import 'package:the_moscow_post/controllers/context/context_controller.dart';
import 'package:the_moscow_post/data/models/news.dart';
import 'package:the_moscow_post/utils/constans/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utils/constans/edit_text.dart';
import '../../utils/constans/strings.dart';

class NewsDetails extends StatefulWidget {
  NewsDetails({
    required this.news,
    super.key,
    required this.listNews,
    required this.numberItem,
  });

  final News news;
  int numberItem;
  List<News> listNews;

  @override
  State<NewsDetails> createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {
   // Для Android
  // WebView.platform = SurfaceWebView();
  @override
  Widget build(BuildContext context) {// Для Android
    // WebView.platform = SurfaceWebView();
    bool isPreviewNews = false;
    News? news;
    print(widget.numberItem);
    if (widget.numberItem > 0 && widget.numberItem <= widget.listNews.length) {
      news = widget.listNews[widget.numberItem - 1];
      isPreviewNews = true;
    } else if (widget.numberItem <= widget.listNews.length) {
      widget.numberItem = 2;
      setState(() {
        news = widget.listNews[widget.numberItem - 1];
        isPreviewNews = true;
      });
    }
    print(widget.listNews[0].title);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(82, 82, 82, 1),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 35,
            color: AppColors.secondary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/world.png"),
              fit: BoxFit.cover,
            ),
          ),
          height: kToolbarHeight,
          width: 330,
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
          SizedBox(
            width: 50,
          )
        ],
      ),
      body: Container(
        color: AppColors.secondary,
        height: window.physicalSize.height,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: ContextController.getHeightScreen(
                context), // Устанавливаем минимальную высоту
          ),
          child: SingleChildScrollView(
              child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                        spreadRadius: 0.01,
                        blurRadius: 10,
                        offset: Offset(0, 3)
                        // changes position of shadow
                        ),
                  ],
                ),
                child: ClipRRect(
                  child: Stack(
                    children: [
                      Container(
                        height: 250,
                        margin: const EdgeInsets.only(top: 5, bottom: 5),
                        padding: const EdgeInsets.only(top: 5, bottom: 0),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                                NetworkImage(widget.news.mediumImageTitleUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Градиентный оверлей
                      Container(
                        height: 255,
                        // Установите высоту в соответствии с изображением
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.primary.withOpacity(0.75),
                              AppColors.primary.withOpacity(0.5),
                              Colors.transparent
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                      Positioned(
                          bottom: 20,
                          left: 10,
                          child: Column(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                width:
                                    ContextController.getWidthScreen(context),
                                child: Text(
                                  EditText.removeHtmlTag(widget.news.title),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: "montserrat",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                width:
                                    ContextController.getWidthScreen(context),
                                padding: const EdgeInsets.only(left: 10),
                                child: widget.news.author != ""
                                    ? Row(
                                        children: [
                                          Text(
                                              "Автор: ${widget.news.author}  |  ",
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontFamily: "open_sans",
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              )),
                                          Text(
                                              "Время: ${widget.news.updateDateTime.hour}:${widget.news.updateDateTime.minute.toString().length == 1 ? "0${widget.news.updateDateTime.minute}" : widget.news.updateDateTime.minute}",
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontFamily: "open_sans",
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              )),
                                        ],
                                      )
                                    : Text(
                                        "Время: ${widget.news.updateDateTime.hour}:${widget.news.updateDateTime.minute}",
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontFamily: "open_sans",
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        )),
                              )
                            ],
                          )),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      EditText.removeHtmlTag(widget.news.description),
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: "open_sans",
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Html(
                      data: widget.news.text,
                      style: {
                        "h1": Style(
                          fontSize: FontSize.xSmall,
                          fontFamily: "open_sans",
                          fontWeight: FontWeight.w600,
                        ),
                        "p": Style(
                          fontSize: FontSize.medium,
                          fontFamily: "open_sans",
                          fontWeight: FontWeight.normal,
                        ),
                      },
                      onLinkTap: (url, _, __) {
                        printInfo(info: url!);
                        _launchURL(url!);
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    (isPreviewNews && news != null)
                        ? AppNewsCardHorizontal(
                            news: news!,
                            numberItem: widget.numberItem - 1,
                            listNews: widget.listNews,
                          )
                        : const Text(""),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                            color: AppColors.secondary,
                            margin: const EdgeInsets.only(top: 10, bottom: 10),
                            child: ElevatedButton(
                                onPressed: () {
                                  Share.share(
                                      "${Strings.baseUrl}${widget.news.fullUrl}");
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: const EdgeInsets.all(8),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                child: Column(
                                  children: [
                                    const Text("Поделиться",
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontFamily: "montserrat",
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600)),
                                    SizedBox(
                                      width: ContextController.getWidthScreen(
                                              context) -
                                          36,
                                    )
                                  ],
                                ))),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )),
        ),
      )
      ,
    );
  }
  void _launchURL(String url) async {
    // showModalBottomSheet(context: context, builder: (BuildContext context) {
    //   return WebViewWidget(controller: WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted)..loadRequest(Uri.parse(url!)));
    // });
    // if (await canLaunch(url)) {
    try {
      await launch(url);
    } on Exception catch (ex) {
      printError(info: ex.toString());
      await launch("${Strings.baseUrl}$url");// } else {
    }
    //   throw 'Could not launch $url';
    // }
  }
}
