import 'package:flutter/material.dart';

import '../../../../utils/constans/colors.dart';
import '../../../../utils/constans/edit_text.dart';
import '../../../../utils/constans/strings.dart';

class FirstNewsCardHorizontal extends StatelessWidget {
  const FirstNewsCardHorizontal({required this.title, required this.mediumImageTitleUrl, super.key,});
  final String title;
  final String mediumImageTitleUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(

      child: Stack(
        children: [
          Container(
            height: 170,
            margin: const EdgeInsets.only(
                top: 5, bottom: 5),
            padding: const EdgeInsets.only(
                top: 5, bottom: 0),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    mediumImageTitleUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Градиентный оверлей
          Container(
            height: 175,
            // Установите высоту в соответствии с изображением
            decoration: BoxDecoration(

              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary
                      .withOpacity(0.75),
                  AppColors.primary
                      .withOpacity(0.5),
                  Colors.transparent
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(
                    225, 224, 209, 0.7),
                borderRadius: BorderRadius.all(
                    Radius.circular(30)),
              ),
              child: const Text(
                Strings.newsHour,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "montserrat",
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 10,
            child: Container(
              width: 250,
              child: Text(
                EditText.removeHtmlTag(title),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: "montserrat",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
