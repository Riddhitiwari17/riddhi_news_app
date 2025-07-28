import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/news_bloc/news_bloc.dart';
import 'repositories/news_repository.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final NewsRepository newsRepository = NewsRepository();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NewsBloc>(create: (_) => NewsBloc(newsRepository)),
      ],
      child: MaterialApp(
        title: 'Riddhi News App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          cardColor: Colors.white,
          scaffoldBackgroundColor: const Color(0xFFF5F5F5),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.pink.shade400,
            foregroundColor: Colors.white,
          ),
        ),
        home: HomeScreen(),
      ),
    );
  }
}
