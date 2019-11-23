import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xns_notes/models/Folder.dart';
import 'package:xns_notes/models/Note.dart';

class XnsDatabase extends ChangeNotifier {

  static final XnsDatabase _instance = new XnsDatabase.internal();

  factory XnsDatabase() => _instance;

  static Database _db;
  final String notesTable = 'notes';
  final String idCol = 'id';
  final String titleCol = 'title';
  final String contentCol = 'content';
  final String colorCol = 'color';
  final String noteFolderId = 'folder_id';
  
  final String foldersTable = 'folders';
  final String folderIdCol = 'id';
  final String folderNameCol = 'name';

  int buttonNumber = 1;

  XnsDatabase.internal();

  // get db
  Future<Database> get database async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  // initialize db
  initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'xns_notes.db');

    var db = await openDatabase(
      // Set the path to the database.
      path,
      // When the database is first created, create a table to store notes
      onCreate: _onCreate,
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );

    return db;
  }

  void _onCreate (Database db, int version) async {
    await db.execute(
      "CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, content TEXT, color VARCHAR, folder_id INTEGER)"
    );
    await db.execute(
      "CREATE TABLE folders(id INTEGER PRIMARY KEY, name VARCHAR)"
    );
    await db.execute(
      "INSERT INTO folders ($folderNameCol) VALUES ('All Notes')"
    ); // Create "All Notes" Folder
  }

  // insert Note to db
  Future<void> insertNote(Note note) async {
    final Database db = await database;
    
    await db.insert(notesTable,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    ).then((res) => {
      notifyListeners()
    });
  }
  
  Future<void> createFolder(Folder folder) async {
    final Database db = await database;

    await db.insert(foldersTable,
      folder.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    ).then((res) => {
      notifyListeners()
    });
  }

  get incrementNo => buttonNumber++;

  // retrieve list of Notes from db
  Future<List<Note>> notes() async {
    final Database db = await database; // get reference to db

    final List<Map<String, dynamic>> maps = await db.query(notesTable, limit: 5, orderBy: "$folderIdCol DESC"); // query table for all notes

    // Convert List<Map<String, dynamic>> to List<Note>
    return List.generate(maps.length, (i) {
      return Note(
        id: maps[i][idCol],
        title: maps[i][titleCol],
        content: maps[i][contentCol],
        color: maps[i][colorCol],
        folderId: maps[i][noteFolderId],
      );
    });
  }

  // fetch notes by folder
  Future<List<Note>> notesByFolder(int folderId) async {
    final Database db = await database; // get reference to db

    final List<Map<String, dynamic>> maps = await db.query(notesTable,
    columns: [idCol, titleCol, contentCol, colorCol, noteFolderId],
    where: "folder_id = ?",
    whereArgs: [folderId]); // query table for all notes

    // Convert List<Map<String, dynamic>> to List<Note>
    return List.generate(maps.length, (i) {
      return Note(
        id: maps[i][idCol],
        title: maps[i][titleCol],
        content: maps[i][contentCol],
        color: maps[i][colorCol],
        folderId: maps[i][noteFolderId],
      );
    });
  }

  // retrieve list of Folders from db
  Future<List<Folder>> folders() async {
    final Database db = await database; // get reference to db

    final List<Map<String, dynamic>> maps = await db.query(foldersTable, orderBy: "$folderNameCol ASC"); // query table for all notes

    // Convert List<Map<String, dynamic>> to List<Folder>
    // return List.generate(maps.length,  (i) {
    //   // int notesCount = await notesCountByFolder(maps[i][folderIdCol]);
    //   return Folder(
    //     id: maps[i][folderIdCol],
    //     name: maps[i][folderNameCol],
    //     // notesCount: notesCount
    //   );
    // });
    return await _foldersGenerator (maps);
  }

  Future<List<Folder>> _foldersGenerator (maps) async {
    List<Folder> returnedList = List<Folder>();
    for(var i = 0; i < maps.length; i++) {
      int notesCount = await notesCountByFolder(maps[i][folderIdCol]);
      returnedList.add(Folder(
        id: maps[i][folderIdCol],
        name: maps[i][folderNameCol],
        notesCount: notesCount
      ));
    }
    return returnedList;
  }

  // Update Note in the db
  Future<void> updateNote(Note note) async {
    final Database db = await database; // get reference to db

    // Update given Note
    await db.update(notesTable,
      note.toMap(),
      where: "id = ?", // making sure note has right id
      whereArgs: [note.id], // passing note id in whereErgs to prevent SQL injection
      conflictAlgorithm: ConflictAlgorithm.replace,
    ).then((res) => {
      notifyListeners()
    });
  }

  // Update Note's folder id
  Future<void> updateNotesFolder(int noteId, int folderId) async {
    final Database db = await database; // get reference to db

    Map<String, dynamic> newData = {"folder_id": folderId};
    // Update given Note
    await db.update(notesTable,
      newData,
      where: "id = ?", // making sure note has right id
      whereArgs: [noteId], // passing note id in whereErgs to prevent SQL injection
      conflictAlgorithm: ConflictAlgorithm.replace,
    ).then((res) => {
      notifyListeners()
    });
  }

  // Fetch Note from the db
  Future<Note> fetchNote(int id) async {
    final Database db = await database; // get reference to db

    // get note by id
    List<Map> results = await db.query(notesTable,
    columns: [idCol, titleCol, contentCol, colorCol, noteFolderId],
    where: 'id = ?',
    whereArgs: [id]);

    if(results.length > 0){
      return Note(
        id: results.first[idCol],
        title: results.first[titleCol],
        content: results.first[contentCol],
        color: results.first[colorCol],
        folderId: results.first[noteFolderId],
      );
    } else {
      return Note();
    }
  }

  // fetch notes by title/content
  Future<List<Note>> searchForNote(String query) async {
    final Database db = await database; // get reference to db

    final List<Map<String, dynamic>> results = await db.query(notesTable,
    columns: [idCol, titleCol, contentCol, colorCol, noteFolderId],
    where: "title LIKE '%"+query+"%'",
    // whereArgs: [query] // query table for notes with title == %$query%
    );

    // Convert List<Map<String, dynamic>> to List<Note>
    if(results.length > 0){
      return List.generate(results.length, (i) {
        return Note(
          id: results[i][idCol],
          title: results[i][titleCol],
          content: results[i][contentCol],
          color: results[i][colorCol],
          folderId: results[i][noteFolderId],
        );
      });
    } else {
      return <Note>[];
    }
  }

  // Fetch Folder from the db
  Future<Folder> fetchFolder(int id) async {
    final Database db = await database; // get reference to db

    // get note by id
    List<Map> results = await db.query(foldersTable,
    columns: [folderIdCol, folderNameCol],
    where: 'id = ?',
    whereArgs: [id]);

    var notesCount = await notesCountByFolder(results.first[folderIdCol]);
    
    return Folder(
      id: results.first[folderIdCol],
      name: results.first[folderNameCol],
      notesCount: notesCount
    );
  }

  // count notes by folder
  Future<int> notesCountByFolder(int folderId) async {
    final Database db = await database; // get reference to db

    // get note by id
    return Sqflite.firstIntValue(await db.rawQuery("SELECT count(*) FROM notes where folder_id = ? ", [folderId]));
  }

  // Delete note from db
  Future<void> deleteNote(int id) async {
    final Database db = await database; // get reference to db

    // delete given note
    await db.delete(notesTable,
      where: "id = ?",
      whereArgs: [id],
    ).then((res) => {
      notifyListeners()
    });
  }

  // Delete folder from db
  Future<void> deleteFolder(int id) async {
    final Database db = await database; // get reference to db

    // delete notes belonging to folder
    // first get list of ids of notes which have folder id as foreign key
    await db.query(notesTable,
    columns: [idCol],
    where: 'folder_id = ?',
    whereArgs: [id]).then((res){
      if(res.length > 0){
        res.forEach((note) async {
          await db.delete(notesTable,
            where: "id = ?",
            whereArgs: [note["id"]],
          );
        });
      }
    }).then((res) => {
      notifyListeners()
    });

    // delete given folder
    await db.delete(foldersTable,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // close db connection
  Future close() async {
    var db = await database;
    return db.close();
  }
}