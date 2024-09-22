import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Ensure you import flutter_bloc if you use BLoC
import 'package:movie_app/Pages/ProfilePage/ProfilePages/passwordPage.dart';

import './Pages/Home.dart';
import 'Pages/HomeScreen/HomeScreen.dart';
import 'bloc/searchBloc/SearchLogic.dart';
import 'components/cards.dart';
import 'bloc/movieDetailsBloc/MovieDetailsLogic.dart'; // Import your BLoC logic
import 'bloc/loveBloc/LoveLogic.dart'; // Import your BLoC logic

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print("Firebase Initialized");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MovieDetailsLogic()),
        BlocProvider(create: (context) => LoveLogic()),
        BlocProvider(create: (context) => SearchLogic()),
        // Add other providers here if needed
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const Home(),
        routes: {
          '/postDetail': (context) {
            final int movieId = ModalRoute.of(context)!.settings.arguments as int;
            return PostDetail(movieId: movieId);
          },
          '/home': (context) => const HomeScreen(),
          '/Main': (context) => const Home(),

        },
      ),
    );
  }
}
