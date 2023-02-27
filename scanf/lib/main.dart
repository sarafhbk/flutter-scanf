// @dart=2.9
import 'package:scanf/screens/loading.dart';
import 'package:scanf/screens/login7/login.dart';
import 'package:flutter/material.dart';
//import 'screens/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationProvider>(
          create: (_) => AuthenticationProvider(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationProvider>().authState,
          initialData: null,
        )
      ],
      child: const MaterialApp(
          title: 'Firebase Authentication',
          home: Authenticate(),
          debugShowCheckedModeBanner: false),
    );
  }
}

class Authenticate extends StatelessWidget {
  const Authenticate({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      return const LoadingPage();
    }
    return const Login7();
  }
}
