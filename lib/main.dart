import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'n.dart';

//part 'note.g.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<Note>('notes');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textEditingController = TextEditingController();
  final Box<Note> _notesBox = Hive.box<Note>('notes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _notesBox.listenable(),
              builder: (context, Box<Note> box, _) {
                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final note = box.getAt(index);
                    return ListTile(
                      title: Text(note!.text),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          box.deleteAt(index);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(179, 179, 179, 1))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(0, 78, 131, 10))),
                      hintText: 'write note',
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(0, 255, 255, 255),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      width: 1,
                      color: Color.fromRGBO(0, 78, 131, 10),
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.add_rounded,
                      color: Color.fromRGBO(0, 78, 131, 10),
                    ),
                    onPressed: () {
                      final text = _textEditingController.text;
                      final note = Note()
                        ..text = text
                        ..createdAt = DateTime.now();
                      _notesBox.add(note);
                      _textEditingController.clear();
                    },
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

@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  late String text;

  @HiveField(1)
  late DateTime createdAt;
}
