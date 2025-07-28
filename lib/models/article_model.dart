class Article {
  final String title;
  final String description;
  final String urlToImage;
  final String content;
  final String url;

  Article({
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.content,
    required this.url,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
    title: json['title'] ?? '',
    description: json['description'] ?? '',
    urlToImage: json['urlToImage'] ?? '',
    content: json['content'] ?? '',
    url: json['url'] ?? '',
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Article && runtimeType == other.runtimeType && url == other.url;

  @override
  int get hashCode => url.hashCode;
}
