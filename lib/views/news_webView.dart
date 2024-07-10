import 'package:adblocker_webview/adblocker_webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';


class NewsWebView extends StatefulWidget {
  final String url;

  const NewsWebView({
    super.key,
    required this.url,
  });

  @override
  State<NewsWebView> createState() => _NewsWebViewState();
}

class _NewsWebViewState extends State<NewsWebView> {
  final _adBlockerWebviewController = AdBlockerWebviewController.instance;
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    _adBlockerWebviewController.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // iconTheme: const IconThemeData(color: Colors.black),
        //automaticallyImplyLeading: false,
        centerTitle: true,
        // backgroundColor: Colors.white,
        elevation: 2,
        title: SvgPicture.asset(
          'images/NewsLinksLogo.svg',
          semanticsLabel: 'Logo',
          fit: BoxFit.none,
        ),
      ),
      body:
      Stack(
        children: [
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : const SizedBox(),
          Column(
            children: [
              Expanded(
                child: AdBlockerWebview(url: Uri.parse(widget.url),
                    adBlockerWebviewController: _adBlockerWebviewController,
                    shouldBlockAds: true,
                      onLoadFinished: (controller, url) {
                        setState(() {
                          isLoading = false;
                        });
                        },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
