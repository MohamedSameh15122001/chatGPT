import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Message {
  int? id;
  String? message;

  Message({this.id, this.message});

  Map<String, dynamic> toMap() {
    return {'id': id, 'message': message};
  }

  Message.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    message = map['message'];
  }
}

class MessageDatabaseHelper {
  static final MessageDatabaseHelper _instance =
      MessageDatabaseHelper._internal();

  factory MessageDatabaseHelper() => _instance;

  static late Database _database;

  Future<Database> get database async {
    // if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  MessageDatabaseHelper._internal();

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'message_database.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE messages(id INTEGER PRIMARY KEY AUTOINCREMENT, message TEXT)');
    });
  }

  Future<int> insertMessage(Message message) async {
    final db = await database;
    return await db.insert('messages', message.toMap());
  }

  Future<List<Message>> getAllMessages() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('messages');
    return List.generate(maps.length, (i) {
      return Message(
        id: maps[i]['id'],
        message: maps[i]['message'],
      );
    });
  }

  Future<void> deleteAllMessages() async {
    final db = await database;
    await db.delete('messages');
  }
}
//Use the helper class to insert new messages,
// final message = Message(message: 'Hello, world!');
// final dbHelper = MessageDatabaseHelper();
// final id = await dbHelper.insertMessage(message);
// print('Inserted message with id $id');


//To retrieve all messages
// final dbHelper = MessageDatabaseHelper();
// final messages = await dbHelper.getAllMessages();
// messages.forEach((message) {
//   print('Message id: ${message.id}, message: ${message.message}');
// });

//to delete
// final dbHelper = MessageDatabaseHelper();
// await dbHelper.deleteAllMessages();
// print('All messages deleted');