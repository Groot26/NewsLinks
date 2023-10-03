//model
class NewsArticle {
  final String status;
  final int totalResults;
  final List<Article> articles;

  NewsArticle(
      {required this.status,
        required this.totalResults,
        required this.articles});

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    List<Article> articleList = (json['articles'] as List)
        .map((articleJson) => Article.fromJson(articleJson))
        .toList();

    return NewsArticle(
      status: json['status'],
      totalResults: json['totalResults'],
      articles: articleList,
    );
  }
}

class Article {
  final Source? source;
  final String? author;
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  final String? content;

  Article({
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      source: Source.fromJson(json['source']),
      author: json['author'],
      title: json['title'],
      description: json['description'],
      url: json['url'],
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'],
      content: json['content'],
    );
  }
}

class Source {
  final String? id;
  final String name;

  Source({required this.id, required this.name});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json['id'],
      name: json['name'],
    );
  }
}
