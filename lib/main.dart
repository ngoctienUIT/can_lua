import 'package:can_lua/provider/main_provider.dart';
import 'package:can_lua/pages/login/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  return runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MainProvider(),
      child: MaterialApp(
        theme: ThemeData(fontFamily: 'Lobster'),
        title: 'Cân lúa',
        home: const LoginPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
