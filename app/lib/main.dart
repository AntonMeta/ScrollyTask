// Scrolly Recruitment Kit - Flutter coding challenge template

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:app/features/timer/timer_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:app/views/main_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Hive.initFlutter();

  await Hive.openBox('timer_data');

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TimerService())],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          brightness: Brightness.light,
          useMaterial3: true,
          textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
        ),

        darkTheme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
          textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        ),

        themeMode: ThemeMode.system,
        home: const MainScreen(),
      ),
    );
  }
}
