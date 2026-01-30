// Scrolly Recruitment Kit - Flutter coding challenge template

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/features/timer/timer_service.dart';
import 'package:app/views/home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TimerService())],
      child: MaterialApp(
        title: 'ScrollyTask',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const HomePage(),
      ),
    );
  }
}
