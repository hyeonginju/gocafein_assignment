import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gocafein/UI/screens/home.dart';
import 'package:gocafein/logic/blocs/search_movie/search_movie_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<List>('searchBox'); // 리스트 저장용 박스
  runApp(const MyApp());
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
