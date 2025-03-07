import 'package:challenges/presentation/add_notes.dart';
import 'package:challenges/presentation/note_builder.dart';
import 'package:flutter/material.dart';

import '../data/models/notes.dart';
import '../data/source/db_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _databaseService = DatabaseService();

  Future<List<Notes>> _getNotes() async {
    return await _databaseService.getNotes();
  }

  // Future<void> _onDogDelete(Dog dog) async {
  //   await _databaseService.deleteDog(dog.id!);
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('NOTES'),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Add notes'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Notes'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AddNoteScreen(),
            RefreshIndicator(
              onRefresh: () => _getNotes(),
              child: NotesBuilder(
                future: _getNotes(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

