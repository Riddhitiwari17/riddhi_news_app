import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riddhi_news_app/models/article_model.dart';
import 'package:riddhi_news_app/repositories/news_repository.dart';
import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository newsRepository;
  final List<Article> _articles = [];
  final List<Article> _bookmarks = [];

  NewsBloc(this.newsRepository) : super(NewsInitial()) {
    on<FetchNewsByCategory>(_onFetchNews);
    on<SearchNews>(_onSearchNews);
    on<ToggleBookmark>(_onToggleBookmark);
  }

  void _onFetchNews(FetchNewsByCategory event, Emitter<NewsState> emit) async {
    try {
      if (event.page == 1) {
        emit(NewsLoading());
        _articles.clear();
      }

      final newArticles = await newsRepository.fetchTopHeadlines(
        event.category,
        page: event.page,
      );

      _articles.addAll(newArticles);

      emit(
        NewsLoaded(
          articles: _articles,
          bookmarks: _bookmarks,
          hasMore: newArticles.length == 20,
        ),
      );
    } catch (e) {
      emit(NewsError('Failed to fetch news'));
    }
  }

  void _onSearchNews(SearchNews event, Emitter<NewsState> emit) async {
    try {
      emit(NewsLoading());
      final results = await newsRepository.fetchNews(event.query);
      emit(
        NewsLoaded(articles: results, bookmarks: _bookmarks, hasMore: false),
      );
    } catch (e) {
      emit(NewsError('Search failed'));
    }
  }

  void _onToggleBookmark(ToggleBookmark event, Emitter<NewsState> emit) {
    if (_bookmarks.contains(event.article)) {
      _bookmarks.remove(event.article);
    } else {
      _bookmarks.add(event.article);
    }

    if (state is NewsLoaded) {
      emit(
        NewsLoaded(
          articles: (state as NewsLoaded).articles,
          bookmarks: _bookmarks,
          hasMore: (state as NewsLoaded).hasMore,
        ),
      );
    }
  }
}
