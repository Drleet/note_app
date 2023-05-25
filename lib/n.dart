import 'package:hive/hive.dart';

import 'main.dart';

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final int typeId = 0;

  @override
  Note read(BinaryReader reader) {
    final numOfFields = 3;
    final fields = <int, dynamic>{
      0: null,
      1: null,
      2: null,
    };
    for (var i = 0; i < numOfFields; i++) {
      final key = reader.readByte();
      switch (key) {
        case 0:
          fields[key] = reader.read();
          break;
        case 1:
          fields[key] = reader.read();
          break;
        case 2:
          fields[key] = reader.read();
          break;
      }
    }
    return Note(
      title: fields[0] as String,
      content: fields[1] as String,
      timestamp: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Note note) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(note.title)
      ..writeByte(1)
      ..write(note.content)
      ..writeByte(2)
      ..write(note.timestamp);
  }
}
