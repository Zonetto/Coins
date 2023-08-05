import 'package:firebase/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/auth.dart';
import 'screens/loading_screen.dart';
import 'screens/login_and_sign_screen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
          create: (_) => Auth(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (ctx, auth, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: auth.isAuth!
            ? const HomeScreen()
            : FutureBuilder(
                future: auth.tryAuthLogin(),
                builder: (ctx, snapShot) =>
                    (snapShot.connectionState == ConnectionState.waiting)
                        ? const LoadingScreen()
                        : LoginAndSignScreen(),
              ),
      ),
    );
  }
}
