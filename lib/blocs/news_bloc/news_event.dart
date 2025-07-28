import 'package:riddhi_news_app/models/article_model.dart';

abstract class NewsEvent {}

class FetchNewsByCategory extends NewsEvent {
  final String category;
  final int page;

  FetchNewsByCategory(this.category, {this.page = 1});
}

class SearchNews extends NewsEvent {
  final String query;

  SearchNews(this.query);
}

class ToggleBookmark extends NewsEvent {
  final Article article;

  ToggleBookmark(this.article);
}

