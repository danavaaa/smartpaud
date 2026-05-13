import 'package:flutter/material.dart';
import 'features/auth/login_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Widget utama aplikasi
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Menghilangkan banner DEBUG di pojok kanan atas
      debugShowCheckedModeBanner: false,

      // Theme aplikasi
      theme: ThemeData(
        // Mengatur font default aplikasi menjadi Poppins
        fontFamily: 'Poppins',
      ),

      // Delegates untuk mendukung lokalizasi (multibahasa)
      localizationsDelegates: const [
        // Localization untuk Material widget
        GlobalMaterialLocalizations.delegate,

        // Localization widget umum Flutter
        GlobalWidgetsLocalizations.delegate,

        // Localization untuk Cupertino widget (iOS style)
        GlobalCupertinoLocalizations.delegate,
      ],

      // Daftar bahasa yang didukung aplikasi
      supportedLocales: const [
        // Bahasa Indonesia
        Locale('id', 'ID'),

        // Bahasa Inggris US
        Locale('en', 'US'),
      ],

      // Halaman pertama saat aplikasi dibuka
      home: const LoginPage(),
    );
  }
}
