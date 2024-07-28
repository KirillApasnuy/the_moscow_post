import "dart:ui";

import "package:flutter/material.dart";
import "package:mini_music_visualizer/mini_music_visualizer.dart";
import "package:radio_player/radio_player.dart";
import "package:the_moscow_post/controllers/context/context_controller.dart";
import "package:the_moscow_post/utils/constans/colors.dart";

import "../utils/constans/strings.dart";

class RadioScreen extends StatefulWidget {
  const RadioScreen({super.key});

  @override
  State<RadioScreen> createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen> {
  late RadioPlayer radioPlayer;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    radioPlayer = RadioPlayer();
    radioPlayer.setChannel(title: "The Moscow Post", url: Strings.radioUrl, imagePath: "https://i.imgur.com/CWxlPpP.png");
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
                    Spacer(),
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
                        )),
                    Spacer(),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacer(),
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
                        )),
                    Spacer(),
                  ],
                ),
              ],
            ),
          ),
          Center(
            child: IconButton(
              onPressed: () {
                if (isPlaying) {
                  radioPlayer.pause();
                } else {
                  radioPlayer.play();
                }
                setState(() {
                  isPlaying = !isPlaying;
                });
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
