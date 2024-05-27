import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gocafein/UI/screens/home.dart';
import 'package:gocafein/logic/blocs/search_movie/search_movie_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'goCafein assignment',
      theme: ThemeData(
        fontFamily: 'NanumBarunGothic',
      ),
      home: BlocProvider(
          create: (context) => SearchMovieBloc(), child: HomeScreen()),
    );
  }
}
