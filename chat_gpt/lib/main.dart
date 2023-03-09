import 'package:chat_gpt/modules/home.dart';
import 'package:chat_gpt/modules/splash.dart';
import 'package:chat_gpt/shared/main_cubit/main_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  // Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainCubit(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ChatGPT',
        // theme: ThemeData(
        //   primarySwatch: Colors.blue,
        // ),
        home: SplashScreen(),
      ),
    );
  }
}
