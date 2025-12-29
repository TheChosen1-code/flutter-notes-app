import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire/home.dart';

class NewNote extends StatefulWidget {
  const NewNote({super.key});
  @override
  State<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  final title = TextEditingController();
  final content = TextEditingController();
  bool isPublic = false;

  @override
  void dispose() {
    title.dispose();
    content.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        elevation: 10,
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 63, 59, 59),
        title: Text(
          'New Note',
          style: TextStyle(fontSize: 28, color: Colors.white),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image(image: AssetImage('assets/bg.png'), fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Flex(
              direction: Axis.vertical,
              children: [
                SizedBox(height: h * 0.02),
                SizedBox(
                  height: h * 0.07,
                  child: TextField(
                    controller: title,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Title',
                      hintStyle: TextStyle(
                        color: Color.fromARGB(75, 0, 0, 0),
                        fontSize: 28,
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(139, 255, 255, 255),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(60),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: h * 0.015),
                Expanded(
                  child: TextField(
                    controller: content,
                    expands: true,
                    maxLines: null,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Content',
                      hintStyle: TextStyle(
                        color: const Color.fromARGB(75, 0, 0, 0),
                        fontSize: 28,
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(139, 255, 255, 255),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: h * 0.015),
                SizedBox(
                  height: h * 0.10,
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(139, 255, 255, 255),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 15),
                          Icon(Icons.file_upload, size: 30),
                          Text('Insert Media', style: TextStyle(fontSize: 25)),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: h * 0.02),
                SizedBox(
                  height: h * 0.065, // ~6.5%
                  child: PopupMenuButton<String>(
                    onSelected: (value) async {
                      final user = FirebaseAuth.instance.currentUser;

                      if (user == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('User not logged in')),
                        );
                        return;
                      }

                      if (title.text.trim().isEmpty ||
                          content.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Title and content cannot be empty'),
                          ),
                        );
                        return;
                      }

                      try {
                        if (value == 'private') {
                          await FirebaseFirestore.instance
                              .collection('notes')
                              .add({
                                'userId': user.uid,
                                'title': title.text.trim(),
                                'content': content.text.trim(),
                                'isPublic': false,
                                'createdAt': FieldValue.serverTimestamp(),
                              });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Saved in My Notes')),
                          );

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                          );
                        } else if (value == 'public') {
                          await FirebaseFirestore.instance
                              .collection('notes')
                              .add({
                                'userId': user.uid,
                                'title': title.text.trim(),
                                'content': content.text.trim(),
                                'isPublic': true,
                                'createdAt': FieldValue.serverTimestamp(),
                              });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Shared to Public Feed'),
                            ),
                          );

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Firestore error: $e')),
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'private',
                        child: Text('Save To Private'),
                      ),
                      PopupMenuItem(
                        value: 'public',
                        child: Text('Share Feed To Public'),
                      ),
                    ],
                    child: TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: Colors.amber,
                      ),
                      onPressed: null,
                      child: Text(
                        'Save Note',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
