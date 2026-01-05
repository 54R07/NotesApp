import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isarcrud/components/drawer.dart';
import 'package:isarcrud/components/note_tile.dart';
import 'package:isarcrud/models/note.dart';
import 'package:isarcrud/models/note_database.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {

  // text controller to access what the user typed
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // on app startup, fetch existing notes
    readNotes();
  }

  // create a note
  void createNote(){
    showDialog(
      context: context,
      builder: (context)=> AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        content: TextField(
          controller: textController,
        ),
        actions: [
          // create button
          MaterialButton(
            onPressed: (){
              context.read<NoteDatabase>().addNote(textController.text);

              // clear controller
              textController.clear();

              // pop dialog box
              Navigator.of(context).pop();
            },
            child: Text("Create"),
          )
        ],
      )
    );
  }

  // read note
  void readNotes(){
    context.read<NoteDatabase>().fetchNotes();
  }

  // update a note
  void updateNote(Note note){
    // pre fill the current note text
    textController.text = note.text;
    showDialog(
      context: context,
       builder: (context)=>AlertDialog(
       backgroundColor: Theme.of(context).colorScheme.background,
        title: Text("Update"),
        content: TextField(
          controller: textController,
        ),
        actions: [
          MaterialButton(
            onPressed: (){
              // update note to db
              context.read<NoteDatabase>().updateNote(note.id, note.text);

              // clear controller
              textController.clear();

              // pop the dialog box
              Navigator.of(context).pop();
            },
            child: Text("Update"),
          )
        ],
       )
    );
  }

  // delete a note
  void deleteNote(id){
    context.read<NoteDatabase>().deleteNote(id);
  }
  @override
  Widget build(BuildContext context) {

    // note database
    final noteDatabase = context.watch<NoteDatabase>();

    // current note
    List<Note> currentNotes = noteDatabase.currentNotes;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButton: FloatingActionButton(
        onPressed: createNote,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(Icons.add,
        color: Theme.of(context).colorScheme.inversePrimary
        ),
      ),
      drawer: const MyDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // heading
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Text("Notes",
            style: GoogleFonts.dmSerifText(
              fontSize: 40,
              color: Theme.of(context).colorScheme.inversePrimary
            ),
            ),
          ),

          // list of notes
          Expanded(
            child: ListView.builder(
              itemCount: currentNotes.length,
              itemBuilder: (context, index) {
                // get individual note
                final note = currentNotes[index];
            
                // list tile UI
                return NoteTile(
                  text: note.text,
                  onEditPressed: () => updateNote(note),
                  onDeletePressed: ()=> deleteNote(note.id),
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}