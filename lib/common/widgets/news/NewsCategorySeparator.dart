import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../utils/constans/colors.dart';

class NewsCategorySeparator extends StatelessWidget {
  const NewsCategorySeparator(  {super.key, required this.title, required this.function,});

  final Function function;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        function();
      },
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        width: window.physicalSize.width,
        height: 50,
        color: AppColors.primary,
        padding: const EdgeInsets.only(left: 10),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontFamily: "open_sans",
                fontSize: 17,
                color: Colors.white
            ),
          ),
        )
      ),
    );
  }
}
