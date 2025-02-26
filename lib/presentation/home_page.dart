import 'package:challenges/utils/database_helper.dart';
import 'package:flutter/material.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late Future<List<Map<String, dynamic> >> _notes;

  @override
  void initState() {
    super.initState();
    _notes = _fetchNotes();
  }

  Future<List<Map<String, dynamic>>> _fetchNotes() async {
    return await DatabaseHelper.instance.getAllNotes();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notes')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _notes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final notes = snapshot.data;

          if (notes == null || notes.isEmpty) {
            return Center(child: Text('No notes available.'));
          }

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return ListTile(
                title: Text(note['title']),
                subtitle: Text(note['content']),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await DatabaseHelper.instance.deleteNoteById(note['id']);
                    setState(() {
                      _notes = _fetchNotes();
                    });
                  },
                ),
                onTap: () async {
                  final updatedNote = {
                    'id': note['id'],
                    'title': 'Updated: ${note['title']}',
                    'content': 'Updated: ${note['content']}',
                  };
                  await DatabaseHelper.instance.updateNote(updatedNote);
                  setState(() {
                    _notes = _fetchNotes();
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}
