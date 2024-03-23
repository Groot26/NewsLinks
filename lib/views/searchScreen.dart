import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../api_key.dart';
import '../date_converter.dart';
import '../news_model.dart';
import 'newsDetails.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<NewsArticle>? newsData;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    newsData = fetchSearchNewsData("Trending");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back),
                      ),
                    ),
                    Container(
                      width: size.width * 0.86,
                      child: SearchBar(
                        elevation: MaterialStateProperty.all(3),
                        hintText: 'Search....',
                        //hintStyle: MaterialStateProperty.all(const TextStyle(color: Colors.grey)),
                        textStyle: MaterialStateProperty.all(const TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.none)),
                        side: MaterialStateProperty.all(
                            const BorderSide(color: Colors.blueAccent)),
                        controller: controller,
                        padding: const MaterialStatePropertyAll<EdgeInsets>(
                            EdgeInsets.symmetric(horizontal: 16)),
                        onTap: () {
                          //controller.openView();
                        },
                        onChanged: (_) {
                          print(
                              "------------------Searching--------------------");
                          print(controller.value.text);
                          newsData = fetchSearchNewsData(controller.value.text);
                        },
                        onSubmitted: (_) {
                          print("-------------------Submit-------------------");
                          print(controller.value.text);
                          newsData = fetchSearchNewsData(controller.value.text);
                        },
                        leading: const Icon(Icons.search),
                        trailing: <Widget>[
                          Tooltip(
                            message: 'Cancel',
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  controller.clear();
                                });
                              },
                              icon: const Icon(Icons.close),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.8648,
                child: FutureBuilder<NewsArticle>(
                  future: newsData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (newsData == null) {
                      return const Center(child: Text('Error'));
                    } else {
                      final newsData = snapshot.data;
                      return SearchCard(newsData: newsData!);
                    }
                  },
                ),
              )
              //:Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchCard extends StatelessWidget {
  final NewsArticle newsData;

  const SearchCard({super.key, required this.newsData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                            : SizedBox(
                                width: double.maxFinite,
                                height: 200,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(
                                    fit: BoxFit.fill,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(),
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(80),
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                                    //height: 150,
                                    '${article.urlToImage}',
                                  ),
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
                              vertical: 5, horizontal: 10),
                          child: Text(
                            dateConverter(article.publishedAt!),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xFF797A7B)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 15),
            ),
          ),
        ),
      ],
    );
  }
}

//Api
Future<NewsArticle> fetchSearchNewsData(suggestion) async {
  final DateTime now = DateTime.now().subtract(const Duration(days: 2));
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String date = formatter.format(now);
  print(date); // something like 2013-04-20

  final response = await http.get(Uri.parse(
      'https://newsapi.org/v2/everything?q=$suggestion&from=$date&sortBy=popularity&apiKey=$apiKey')); //ADD api key

  if (response.statusCode == 200) {
    return NewsArticle.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load news data');
  }
}
