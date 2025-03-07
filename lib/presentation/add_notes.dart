import 'package:flutter/material.dart';

import '../data/models/notes.dart';
import '../data/source/db_helper.dart';// Import your Notes model

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _saveNote() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      // Show a Snackbar if the text fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter both title and description")),
      );
    } else {
      // Create a new note object
      Notes newNote = Notes(
        title: _titleController.text,
        description: _descriptionController.text,
        time: DateTime.now().toString(),
      );

      // Call the insertNote method from DatabaseService to save the note
      await DatabaseService().insertNote(newNote, newNote); // Insert two identical notes

      // Show a Snackbar that the note is saved
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Note Saved")),
      );

      // Clear the text fields after saving
      _titleController.clear();
      _descriptionController.clear();
    }
  }

  void _clearFields() {
    _titleController.clear();
    _descriptionController.clear();

    // Show a Snackbar that the fields are cleared
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Cleared")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Note"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Title:",
              style: TextStyle(fontSize: 16),
            ),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(hintText: "Enter note title"),
            ),
            SizedBox(height: 10),
            Text(
              "Description:",
              style: TextStyle(fontSize: 16),
            ),
            TextField(
              controller: _descriptionController,
              maxLines: 6, // Set 6 lines for the description text field
              decoration: InputDecoration(hintText: "Enter note description"),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _clearFields,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text("Delete"),
                ),
                ElevatedButton(
                  onPressed: _saveNote,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text("Save"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
