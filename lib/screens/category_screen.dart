import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/article_model.dart';
import '../blocs/news_bloc/news_bloc.dart';
import '../blocs/news_bloc/news_state.dart';
import '../blocs/news_bloc/news_event.dart';
import '../widgets/news_card.dart';
import 'article_screen.dart';

class CategoryScreen extends StatefulWidget {
  final String category;

  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  int _currentPage = 1;
  bool _isLoadingMore = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<NewsBloc>().add(
      FetchNewsByCategory(widget.category, page: _currentPage),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 300 &&
        !_isLoadingMore &&
        _searchQuery.isEmpty) {
      _isLoadingMore = true;
      _currentPage++;
      context.read<NewsBloc>().add(
        FetchNewsByCategory(widget.category, page: _currentPage),
      );
    }
  }

  void _onSearchChanged(String query) {
    _searchQuery = query.trim();
    _currentPage = 1;
    if (_searchQuery.isNotEmpty) {
      context.read<NewsBloc>().add(SearchNews(_searchQuery));
    } else {
      context.read<NewsBloc>().add(
        FetchNewsByCategory(widget.category, page: _currentPage),
      );
    }
  }

  Future<void> _onRefresh() async {
    _currentPage = 1;
    if (_searchQuery.isNotEmpty) {
      context.read<NewsBloc>().add(SearchNews(_searchQuery));
    } else {
      context.read<NewsBloc>().add(
        FetchNewsByCategory(widget.category, page: _currentPage),
      );
    }
  }

  void _showBookmarksBottomSheet(
    BuildContext context,
    List<Article> bookmarks,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        if (bookmarks.isEmpty) {
          return const SizedBox(
            height: 200,
            child: Center(child: Text("No bookmarks yet.")),
          );
        }

        final halfHeight = MediaQuery.of(context).size.height * 0.5;

        return SizedBox(
          height: halfHeight,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  "Bookmarked Articles",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: bookmarks.length,
                    itemBuilder: (context, index) {
                      final article = bookmarks[index];
                      return NewsCard(
                        article: article,
                        isBookmarked: true,
                        onBookmarkToggle: () => context.read<NewsBloc>().add(
                          ToggleBookmark(article),
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ArticleScreen(article: article),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          decoration: const InputDecoration(
            hintText: 'Search news...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
            icon: Icon(Icons.search, color: Colors.white),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          BlocBuilder<NewsBloc, NewsState>(
            builder: (context, state) {
              final hasBookmarks =
                  state is NewsLoaded && state.bookmarks.isNotEmpty;
              return IconButton(
                icon: Icon(
                  Icons.bookmark,
                  color: hasBookmarks ? Colors.yellowAccent : Colors.white,
                ),
                onPressed: () {
                  if (state is NewsLoaded) {
                    _showBookmarksBottomSheet(context, state.bookmarks);
                  }
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsLoading && _currentPage == 1) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NewsLoaded) {
            _isLoadingMore = false;
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: state.articles.length + (state.hasMore ? 1 : 0),
                itemBuilder: (_, index) {
                  if (index < state.articles.length) {
                    final article = state.articles[index];
                    final isBookmarked = state.bookmarks.contains(article);
                    return NewsCard(
                      article: article,
                      isBookmarked: isBookmarked,
                      onBookmarkToggle: () =>
                          context.read<NewsBloc>().add(ToggleBookmark(article)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ArticleScreen(article: article),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              ),
            );
          } else if (state is NewsError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
