import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme.dart';
import 'screens/dashboard.dart';
import 'pages/landing_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAEOI-qEDyJXC-2_7HmAu9anXLL4DgDsFI",
      authDomain: "bookroom-671a1.firebaseapp.com",
      projectId: "bookroom-671a1",
      storageBucket: "bookroom-671a1.appspot.com", // ✅ perbaiki .app jadi .com
      messagingSenderId: "1000139953545",
      appId: "1:1000139953545:web:88363f01ea03991d8f7d58",
      measurementId: "G-MLXBMLL4E8",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const LandingPage(),
    );
  }
}