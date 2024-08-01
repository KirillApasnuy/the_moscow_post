import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_music_visualizer/mini_music_visualizer.dart';
import 'package:radio_player/radio_player.dart';
import 'package:the_moscow_post/controllers/context/context_controller.dart';
import 'package:the_moscow_post/data/controllers/radio_verify_controller.dart';
import 'package:the_moscow_post/data/models/radioVerify.dart';
import 'package:the_moscow_post/data/repositories/repository.dart';
import 'package:the_moscow_post/utils/constans/colors.dart';
import '../utils/constans/strings.dart';

class RadioScreen extends StatefulWidget {
  const RadioScreen({super.key});

  @override
  State<RadioScreen> createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen> {
  final RadioVerifyController radioVerifyController =
      RadioVerifyController(Repository());
  late RadioPlayer radioPlayer;
  bool isPlaying = false;
  RadioVerify? radioVerify;

  @override
  void initState() {
    super.initState();
    radioPlayer = RadioPlayer();
    radioVerifyController.fetchRadioVerify().then((getRadioVerify) {
      setState(() {
        radioVerify = getRadioVerify;
        radioPlayer.setChannel(
          title: "The Moscow Post",
          url: radioVerify?.radioHost ?? Strings.radioUrl,
          imagePath: "https://i.imgur.com/CWxlPpP.png",
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double columnWidth = (ContextController.getWidthScreen(context) * 0.16 - 2);
    return Container(
      width: window.physicalSize.width,
      height: window.physicalSize.height,
      decoration: const BoxDecoration(
        color: AppColors.secondary,
      ),
      child: Stack(
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    MiniMusicVisualizer(
                      color: AppColors.accent.withOpacity(0.5),
                      width: columnWidth,
                      height: 250,
                      radius: 15,
                      animate: isPlaying,
                    ),
                    Transform.rotate(
                      angle: 3.14159,
                      child: MiniMusicVisualizer(
                        color: AppColors.accent.withOpacity(0.5),
                        width: columnWidth,
                        height: 250,
                        radius: 15,
                        animate: isPlaying,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    MiniMusicVisualizer(
                      color: AppColors.accent.withOpacity(0.5),
                      width: columnWidth,
                      height: 250,
                      radius: 15,
                      animate: isPlaying,
                    ),
                    Transform.rotate(
                      angle: 3.14159,
                      child: MiniMusicVisualizer(
                        color: AppColors.accent.withOpacity(0.5),
                        width: columnWidth,
                        height: 250,
                        radius: 15,
                        animate: isPlaying,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
          Center(
            child: IconButton(
              onPressed: () {
                if (radioVerify?.radioOn ?? false) {
                  if (isPlaying) {
                    radioPlayer.pause();
                  } else {
                    radioPlayer.play();
                  }
                  setState(() {
                    isPlaying = !isPlaying;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Container(
                        height: 90,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "В данный момент радио                не работает",
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "montserrat",
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                  );
                }
              },
              icon: isPlaying
                  ? const Icon(Icons.pause)
                  : const Icon(Icons.play_arrow),
              iconSize: 130,
            ),
          ),
        ],
      ),
    );
  }
}
