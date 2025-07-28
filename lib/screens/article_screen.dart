import 'package:flutter/material.dart';
import '../models/article_model.dart';

class ArticleScreen extends StatelessWidget {
  final Article article;

  const ArticleScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          article.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (article.urlToImage.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  article.urlToImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 48),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Text(
              article.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              article.content.isNotEmpty
                  ? article.content
                  : "No content available.",
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 16,
                height: 1.6,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
