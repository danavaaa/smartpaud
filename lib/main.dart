import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  await Supabase.initialize(
    url: 'https://vcwvdgmrydztxpccirxb.supabase.co',
    anonKey: 'sb_publishable_ANq88IGV9M-qLLw_LrN-BQ_Qj2_jrkt',
  );

  runApp(const MyApp());
}
