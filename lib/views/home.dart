import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_wave/date_converter.dart';
import '../api_key.dart';
import '../news_model.dart';
import 'newsDetails.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<NewsArticle> newsData;

  @override
  void initState() {
    super.initState();
    print('printing...');
    newsData = fetchNewsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: SvgPicture.asset(
          'images/NewsLinksLogo.svg',
          semanticsLabel: 'Logo',
          fit: BoxFit.none,
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Icon(
              Icons.search,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: FutureBuilder<NewsArticle>(
        future: newsData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final newsData = snapshot.data;
            return NewsCard(newsData: newsData!);
          }
        },
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final NewsArticle newsData;

  const NewsCard({super.key, required this.newsData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // const Text(
        //   'Top Stories',
        //   style: TextStyle(
        //     fontSize: 22,
        //     fontFamily: 'Poppins',
        //     fontWeight: FontWeight.w600,
        //   ),
        // ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: newsData.articles.length,
              itemBuilder: (BuildContext context, int index) {
                final article = newsData.articles[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetail(article: article),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        article.urlToImage == null
                            ? Container()
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) => Container(),
                                  loadingBuilder: (BuildContext context, Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(80),
                                        child: CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                                  //height: 150,
                                  '${article.urlToImage}',
                                ),
                              ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            article.title!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child:
                          Text(
                            dateConverter(article.publishedAt!),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12,color: Color(0xFF797A7B)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 15,),
            ),
          ),
        ),
      ],
    );
  }
}

//Api
Future<NewsArticle> fetchNewsData() async {
  final response = await http.get(Uri.parse(
      'https://newsapi.org/v2/top-headlines?country=in&apiKey=$apiKey')); //ADD api key

  if (response.statusCode == 200) {
    return NewsArticle.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load news data');
  }
}
