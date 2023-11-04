import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news_wave/date_converter.dart';
import 'package:news_wave/views/news_webView.dart';
import '../news_model.dart';

class NewsDetail extends StatelessWidget {
  final Article article;

  const NewsDetail({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        //automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: SvgPicture.asset(
          'images/NewsLinksLogo.svg',
          semanticsLabel: 'Logo',
          fit: BoxFit.none,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article.title!,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 18,
              ),
              article.urlToImage == null
                  ? Container()
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(),
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(80),
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                        '${article.urlToImage}',
                      ),
                    ),
              const SizedBox(height: 5),
              article.publishedAt == null
                  ? const Text('')
                  : Text(
                      dateConverter(article.publishedAt!),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Color(0xFF797A7B), fontSize: 12),
                    ),
              const SizedBox(height: 5),
              article.author == null
                  ? const Text('')
                  : RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          const TextSpan(
                            text: 'Published By:\n',
                            style: TextStyle(
                                color: Color(0xFF57595A),
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                          ),
                          TextSpan(
                            text: article.author!,
                            style: const TextStyle(
                                color: Color(0xFF2074A9),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
              const SizedBox(height: 15),
              article.description == null
                  ? Container()
                  : const Text(
                      'Overview',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
              article.description == null
                  ? Container()
                  : Text(
                      article.description!,
                      //style: const TextStyle(fontFamily:'Poppins' ),
                    ),
              const SizedBox(height: 20),
              article.content == null || article.content!.isEmpty
                  ? Container()
                  : Text(
                      article.content!
                          .substring(0, article.content!.length - 13),
                    ),
              article.description == null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: SvgPicture.asset(
                          'images/PoorData.svg',
                          semanticsLabel: 'Logo',
                          fit: BoxFit.none,
                        ),
                      ),
                    )
                  : Container(),
              const SizedBox(height: 10),
              Center(
                child: FloatingActionButton.extended(
                  backgroundColor: const Color(0xFF2074A9),
                  label: const Text('See Full Article'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsWebView(url: article.url!),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
