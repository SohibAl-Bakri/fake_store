import 'package:flutter/material.dart';
import 'consts/global_colors.dart';
import 'screens/home_screen.dart';
import 'dart:io';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter 3.0.4 ',
      theme: ThemeData(
        scaffoldBackgroundColor:GlobalColors.scaffoldColor,
        primaryColor: GlobalColors.cardColor,
        // backgroundColor: lightBackgroundColor,
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(
            color: GlobalColors.iconsColor,
          ),
          backgroundColor:GlobalColors.scaffoldColor,
          centerTitle: true,
          titleTextStyle: TextStyle(
              color: GlobalColors.textColor, fontSize: 22, fontWeight: FontWeight.bold),
          elevation: 0,
        ),
        iconTheme: IconThemeData(
          color:GlobalColors.iconsColor,
        ),

        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.black,
          selectionColor: Colors.blue,
          // selectionHandleColor: Colors.blue,
        ),
        // textTheme: TextTheme()
        // textTheme: Theme.of(context).textTheme.apply(
        //       bodyColor: Colors.black,
        //       displayColor: Colors.black,
        //     ),
        cardColor:GlobalColors.cardColor,
        brightness: Brightness.light,
        colorScheme: ThemeData().colorScheme.copyWith(
              secondary: GlobalColors.iconsColor,
              brightness: Brightness.light,
            ),
      ),
      home: const HomeScreen(),
    );
  }
}
