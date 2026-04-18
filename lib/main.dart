import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://vcwvdgmrydztxpccirxb.supabase.co',
    anonKey: 'sb_publishable_ANq88IGV9M-qLLw_LrN-BQ_Qj2_jrkt',
  );

  runApp(const MyApp());
}
