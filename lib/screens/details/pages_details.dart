import "package:flutter/material.dart";
import "package:flutter_html/flutter_html.dart";
import "package:get/get.dart";
import "package:photo_view/photo_view.dart";
import "package:the_moscow_post/data/models/pages.dart";
import "package:the_moscow_post/utils/constants/colors.dart";
import "package:the_moscow_post/utils/constants/strings.dart";
import "package:url_launcher/url_launcher.dart";

class PagesDetails extends StatefulWidget {
  PagesDetails({super.key, required this.pages});

  final Pages pages;

  @override
  State<PagesDetails> createState() => _PagesDetailsState();
}

class _PagesDetailsState extends State<PagesDetails> {
  @override
  Widget build(BuildContext context) {
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
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Html(
                    data: widget.pages.text,
                    style: {
                      "h1": Style(
                        fontSize: FontSize.xLarge,
                        fontFamily: "open_sans",
                        fontWeight: FontWeight.w600,
                      ),
                      "p": Style(
                        fontSize: FontSize.xLarge,
                        fontFamily: "open_sans",
                        fontWeight: FontWeight.normal,
                      ),
                    },
                    onLinkTap: (url, _, __) {
                      _launchURL(url!);
                    },
                    extensions: [
                      TagExtension(
                        tagsToExtend: {"img"},
                        builder: (extensionContext) {
                          final attributes = extensionContext.attributes;
                          final src = attributes['src'];
                          if (src == null) return const SizedBox();

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return FullScreenImage(src: src);
                              }));
                            },
                            child: Image.network(src),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void _launchURL(String url) async {
    try {
      await launch(url);
    } on Exception catch (ex) {
      printError(info: ex.toString());
      await launch("${Strings.baseUrl}$url"); // } else {
    }
  }
}

class FullScreenImage extends StatelessWidget {
  final String src;

  const FullScreenImage({super.key, required this.src});

  @override
  Widget build(BuildContext context) {
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
      body: PhotoView(
        imageProvider: NetworkImage(src),
        backgroundDecoration: const BoxDecoration(
          color: AppColors.secondary,
        ),
      ),
    );
  }
}
