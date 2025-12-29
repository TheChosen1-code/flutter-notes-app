import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire/createnotes.dart';
import 'package:flutterfire/login.dart';
import 'package:flutterfire/mynotes.dart';
import 'package:flutterfire/profile.dart';
import 'package:flutterfire/public.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 90,
          elevation: 10,
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 63, 59, 59),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                child: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'Profile') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ProfileScreen()),
                      );
                    } else if (value == 'Logout') {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'Profile', child: Text('Profile')),
                    PopupMenuItem(value: 'Logout', child: Text('Logout')),
                  ],
                  child: CircleAvatar(backgroundColor: Colors.tealAccent),
                ),
              ),
            ),
          ],
          bottom: TabBar(
            labelColor: Colors.amber,
            unselectedLabelColor: Colors.grey,
            indicatorWeight: 4,
            indicatorColor: Colors.amber,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(text: 'My Notes'),
              Tab(text: 'Public Feed'),
            ],
          ),
          title: const Text("NoteGram", style: TextStyle(fontSize: 28)),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image(
                image: AssetImage('assets/bg.png'),
                fit: BoxFit.cover,
              ),
            ),
            TabBarView(children: [MyNotesPage(), PublicFeedPage()]),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => NewNote()),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
