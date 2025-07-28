import 'package:flutter/material.dart';
import 'category_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {'name': 'General', 'icon': Icons.public, 'color': Colors.indigo},
    {'name': 'Technology', 'icon': Icons.computer, 'color': Colors.blue},
    {'name': 'Sports', 'icon': Icons.sports_soccer, 'color': Colors.green},
    {'name': 'Entertainment', 'icon': Icons.movie, 'color': Colors.purple},
    {'name': 'Health', 'icon': Icons.health_and_safety, 'color': Colors.red},
    {'name': 'Science', 'icon': Icons.science, 'color': Colors.teal},
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riddhi New App')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (_, index) {
            final category = categories[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryScreen(
                      category: category['name'].toLowerCase(),
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      category['color'],
                      category['color'].withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: category['color'].withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(category['icon'], size: 40, color: Colors.white),
                    const SizedBox(height: 10),
                    Text(
                      category['name'].toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
