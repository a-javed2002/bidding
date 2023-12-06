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
  MyHomePage({Key? key});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService authService = AuthService();

  Future<void> _logout(BuildContext context) async {
    try {
      await _auth.signOut();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      print('Error during logout: $e');
      // Handle logout errors here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600), // Adjust as needed
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _getCrossAxisCount(context),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              return _buildTile(context, index);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _logout(context);
        },
        tooltip: 'Logout',
        child: Icon(Icons.logout),
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) {
      return 1; // Single column for smaller screens
    } else {
      return 2; // Two columns for larger screens
    }
  }

  Widget _buildTile(BuildContext context, int index) {
    List<String> titles = ["Create Bid", "View Bids", "View Requests", "Settings"];
    List<IconData> icons = [Icons.add, Icons.list, Icons.person, Icons.settings];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          _handleTileClick(context, index);
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icons[index],
                size: 48,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(height: 8),
              Text(
                titles[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTileClick(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) => CropAdd()));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => CropView()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => StudentView()));
        break;
      case 3:
        // Add navigation to the settings page
        break;
    }
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
