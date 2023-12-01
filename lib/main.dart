import 'package:bid/crop-add.dart';
import 'package:bid/crop.dart';
import 'package:bid/login.dart';
import 'package:bid/student.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyAv6g5sfeThomKzOCVQe7QWBr6nUjR7DBQ",
      appId: "1:99017616392:android:36e3c8aef576700d8d75bd",
      projectId: "bidding-b14b5",
      messagingSenderId: "99017616392",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _logout(BuildContext context) async {
    try {
      await _auth.signOut();
      // Navigate to the login page after successful logout
      // Navigator.pushReplacementNamed(context, '/login');

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      print('Error during logout: $e');
      // Handle logout errors here
    }
  }

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
//       bool userLoggedIn = await authService.isLoggedIn();
// if (userLoggedIn) {
//   // User is logged in
// } else {
//   Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => LoginPage()),
//                     );
// }
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => BatchAdd()),
                    // );
                  },
                  child: Text("Create Batch")),
              ElevatedButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => BatchView()),
                    // );
                  },
                  child: Text("View Batch")),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StudentView()),
                    );
                  },
                  child: Text("View Students")),
              ElevatedButton(onPressed: () {}, child: Text("Setings")),
              ElevatedButton(
                  onPressed: () {
                    _logout(context);
                  },
                  child: Text("Logout")),
            ],
          )
        ],
      ),
    );
  }
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Check if the user is logged in
  Future<bool> isLoggedIn() async {
    User? user = _auth.currentUser;
    return user != null;
  }
}
