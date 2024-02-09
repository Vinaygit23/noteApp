import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:noteapp/Hive/home_screen.dart';
import 'package:path_provider/path_provider.dart';

import 'Hive/notesmodel/notes_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(NotesModelAdapter());
  await Hive.openBox<NotesModel>('notes');
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'noteapp',
      home: HomeScreen(),
    );
  }
}
