import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article_model.dart';

class NewsRepository {
  final String _apiKey = '9905bf04bf2445569312f044e0e00660';
  final String _baseUrl = 'https://newsapi.org/v2';

  Future<List<Article>> fetchNews(String query, {int page = 1}) async {
    final fromDate = '2025-06-28';
    final url =
        '$_baseUrl/everything?q=$query&from=$fromDate&sortBy=publishedAt&page=$page&pageSize=20&apiKey=$_apiKey';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (response.statusCode == 200 && data['status'] == 'ok') {
      return (data['articles'] as List)
          .map((e) => Article.fromJson(e))
          .toList();
    } else {
      throw Exception(data['message'] ?? 'Failed to fetch search results');
    }
  }

  Future<List<Article>> fetchTopHeadlines(
    String category, {
    int page = 1,
  }) async {
    final url =
        '$_baseUrl/top-headlines?country=us&category=$category&page=$page&pageSize=20&apiKey=$_apiKey';
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (response.statusCode == 200 && data['status'] == 'ok') {
      return (data['articles'] as List)
          .map((e) => Article.fromJson(e))
          .toList();
    } else {
      throw Exception(data['message'] ?? 'Failed to fetch top headlines');
    }
  }
}
