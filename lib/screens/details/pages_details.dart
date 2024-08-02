import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:the_moscow_post/data/models/pages.dart';
import 'package:the_moscow_post/utils/constans/colors.dart';
import 'package:the_moscow_post/utils/constans/strings.dart';
import 'package:webview_flutter/webview_flutter.dart';


class PagesDetails extends StatefulWidget {
  PagesDetails({super.key, required this.pages});
  final Pages pages;
  @override
  State<PagesDetails> createState() => _PagesDetailsState();
}

class _PagesDetailsState extends State<PagesDetails> {

  @override
  Widget build(BuildContext context) {
    print("${Strings.baseUrl}/${widget.pages.url}");
    WebViewController webViewController = WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {
          const CircularProgressIndicator(color: AppColors.primary,);
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onHttpError: (HttpResponseError error) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith(Strings.baseUrl)) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ))
      ..loadRequest(Uri.parse("${Strings.baseUrl}/${widget.pages.url}"));
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
      body: WebViewWidget(controller: webViewController,

      ),
    );
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