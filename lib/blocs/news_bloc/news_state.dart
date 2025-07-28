import 'package:riddhi_news_app/models/article_model.dart';

abstract class NewsState {}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<Article> articles;
  final List<Article> bookmarks;
  final bool hasMore;

  NewsLoaded({
    required this.articles,
    required this.bookmarks,
    this.hasMore = true,
  });
}

class NewsError extends NewsState {
  final String message;

  NewsError(this.message);
}
