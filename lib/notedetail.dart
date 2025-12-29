import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NoteDetailPage extends StatefulWidget {
  final String noteId;

  const NoteDetailPage({super.key, required this.noteId});

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  bool isEditing = false;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('notes')
          .doc(widget.noteId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final note = snapshot.data!.data() as Map<String, dynamic>;

        final bool isOwner =
            currentUser != null && note['userId'] == currentUser.uid;

        if (!isEditing) {
          titleController.text = note['title'] ?? '';
          contentController.text = note['content'] ?? '';
        }

        return Scaffold(
          appBar: AppBar(
            title: isEditing
                ? TextField(
                    controller: titleController,
                    decoration: const InputDecoration(border: InputBorder.none),
                  )
                : Text(note['title'] ?? 'Note'),
            actions: [
              if (isOwner)
                IconButton(
                  icon: Icon(isEditing ? Icons.save : Icons.edit),
                  onPressed: () async {
                    if (isEditing) {
                      // SAVE
                      await FirebaseFirestore.instance
                          .collection('notes')
                          .doc(widget.noteId)
                          .update({
                            'title': titleController.text.trim(),
                            'content': contentController.text.trim(),
                            'updatedAt': FieldValue.serverTimestamp(),
                          });
                    }

                    setState(() {
                      isEditing = !isEditing;
                    });
                  },
                ),
              if (isOwner)
                IconButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('notes')
                        .doc(widget.noteId)
                        .delete();
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.delete),
                ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                isEditing
                    ? TextField(
                        controller: contentController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      )
                    : SingleChildScrollView(
                        child: Text(
                          note['content'] ?? '',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                SizedBox(height: 100),
                ElevatedButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('notes')
                        .doc(widget.noteId)
                        .update({'isPublic': !note['isPublic']});
                  },
                  child: Text(
                    note['isPublic']
                        ? 'Turn the Note to Private'
                        : 'Turn the Note to Public',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
