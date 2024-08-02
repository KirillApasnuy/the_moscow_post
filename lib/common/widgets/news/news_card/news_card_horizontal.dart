import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:the_moscow_post/controllers/context/context_controller.dart';
import 'package:the_moscow_post/data/models/news.dart';
import 'package:the_moscow_post/screens/details/news_details.dart';
import 'package:the_moscow_post/utils/constans/colors.dart';
import 'package:the_moscow_post/utils/constans/edit_text.dart';
import 'package:the_moscow_post/utils/constans/strings.dart';

class AppNewsCardHorizontal extends StatelessWidget {
  AppNewsCardHorizontal({
    required this.news,
    super.key,
    required this.listNews,
    required this.numberItem,
  });

  final News news;
  final double height = 140;
  int numberItem = 0;
  List<News> listNews;

  @override
  Widget build(BuildContext context) {
    double screenWidth = ContextController.getWidthScreen(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return NewsDetails(
            news: news,
            numberItem: numberItem,
            listNews: listNews,
          );
        }));
      },
      child: Container(
        width: screenWidth - 14,
        height: height,
        margin: const EdgeInsets.only(left: 7, top: 8, right: 7, bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade800,
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(2, 3),

              // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: height,
              width: 175,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10)),
              ),
              child: Image.network(
                news.mediumImageTitleUrl,
                errorBuilder: (context, error, stackTrace) {
                  printError(
                      info: "Uri not found: ${news.mediumImageTitleUrl}");
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(50),
                        height: height,
                        width: height,
                        child: const CircularProgressIndicator(color: AppColors.primary,),
                      ),
                    ],
                  );
                },
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        EditText.removeHtmlTag(news.title),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 15,
                            fontFamily: "montserrat",
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        EditText.removeHtmlTag(news.description),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontFamily: "open_sans",
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const Spacer(),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 5,
                              ),
                              news.viewCountDisplay ?
                              Row(
                                children: [
                                  Text(
                                    news.viewsCount.toString(),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.remove_red_eye_outlined,
                                    size: 15,
                                    color: AppColors.primary,
                                  )
                                ],
                              ): Row(
                                children: [
                                  const Icon(
                                    Icons.library_books_outlined,
                                    size: 15,
                                    color: AppColors.primary,
                                  ),
                                  Text(
                                    "${news.rubricName.toString()}",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ))
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
