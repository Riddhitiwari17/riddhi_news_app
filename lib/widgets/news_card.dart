import 'package:flutter/material.dart';
import '../models/article_model.dart';

class NewsCard extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;
  final VoidCallback? onBookmarkToggle;
  final bool isBookmarked;

  const NewsCard({
    super.key,
    required this.article,
    required this.onTap,
    this.onBookmarkToggle,
    this.isBookmarked = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Circular image with border
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blueAccent, width: 2),
                ),
                child: ClipOval(
                  child: article.urlToImage.isNotEmpty
                      ? Image.network(
                          article.urlToImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.broken_image, color: Colors.grey[400]),
                        )
                      : Icon(Icons.image, color: Colors.grey[400]),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            article.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        if (onBookmarkToggle != null)
                          IconButton(
                            icon: Icon(
                              isBookmarked
                                  ? Icons.bookmark_rounded
                                  : Icons.bookmark_border_rounded,
                              color: isBookmarked
                                  ? Colors.deepPurple
                                  : Colors.grey[500],
                            ),
                            onPressed: onBookmarkToggle,
                            tooltip: isBookmarked
                                ? 'Remove bookmark'
                                : 'Bookmark',
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      article.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[800],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
