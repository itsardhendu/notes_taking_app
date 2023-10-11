// CRUD Setup into flutter application

import 'package:flutter/foundation.dart';
import 'package:notes_taking_app/service/crud/crudExceptions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

// Service class for managing notes database operations
class NotesService {
  Database? _db;

  // Update an existing note in the database
  Future<DatabaseNote> updateNote({
    required DatabaseNote note,
    required String text,
  }) async {
    final db = _getDatabaseOrThrow();
    await getNote(id: note.id);

    // Update the note's text and set the sync status to unsynced
    final updatesCount = await db.update(notesTable, {
      textColumn: text,
      isSyncedWithCloudColumn: 0,
    });
    if (updatesCount == 0) {
      throw CouldNotUpdateNote();
    } else {
      return await getNote(id: note.id);
    }
  }

  // Get all notes from the database
  Future<Iterable<DatabaseNote>> getAllNotes() async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(notesTable);
    return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
  }

  // Get a specific note from the database by its ID
  Future<DatabaseNote> getNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
      notesTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (notes.isEmpty) {
      throw CouldNotFindNote();
    } else {
      return DatabaseNote.fromRow(notes.first);
    }
  }

  // Delete all notes from the database
  Future<int> deleteAllNotes() async {
    final db = _getDatabaseOrThrow();
    db.delete(notesTable);
    return await db.delete(notesTable);
  }

  // Delete a specific note from the database by its ID
  Future<void> deleteNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      notesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deletedCount == 0) {
      throw CouldNotFindUser();
    }
  }

  // Create a new note in the database for a specific user
  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    final db = _getDatabaseOrThrow();
    // Make sure owner exists in the database with the correct id
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFindUser();
    }
    // Create the note
    const text = '';
    final noteId = await db.insert(notesTable, {
      userIdColumn: owner.id,
      textColumn: text,
      isSyncedWithCloudColumn: 1,
    });
    final note = DatabaseNote(
      id: noteId,
      userId: owner.id,
      text: text,
      isSyncedWithCloud: true,
    );
    return note;
  }

  // Get a user from the database by their email
  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final result = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (result.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return DatabaseUser.fromRow(result.first);
    }
  }

  // Create a new user in the database
  Future<DatabaseUser> createUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isNotEmpty) {
      throw UserAlreadyExists();
    }
    final userId = await db.insert(userTable, {
      emailColumn: email.toLowerCase(),
    });

    return DatabaseUser(
      id: userId,
      email: email,
    );
  }

  // Delete a user from the database by their email
  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  // Function to get the database instance or throw an exception if it's not open
  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  // Function to close the database
  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }

  // Function to open the database
  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      // Get the application documents directory
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);

      // Open the database
      final db = await openDatabase(dbPath);
      _db = db;

      // Create user and notes tables if they don't exist
      await db.execute(createUserTable);
      await db.execute(createNoteTable);
    } on MissingPlatformDirectoryException {
      // Throw exception if unable to get the documents directory
      throw UnableToGetDocumentsDirectory();
    }
  }
}

// Data model for a user in the database
@immutable
class DatabaseUser {
  final int id;
  final String email;

  // Constructor for creating a DatabaseUser object from a database row
  const DatabaseUser({
    required this.id,
    required this.email,
  });

  // Factory method to create a DatabaseUser object from a database row map
  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  // Override toString, ==, and hashCode methods for easier debugging and comparison
  @override
  String toString() => 'User, ID = $id, email = $email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// Data model for a note in the database
class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  // Constructor for creating a DatabaseNote object from individual fields
  DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedWithCloud,
  });

  // Factory method to create a DatabaseNote object from a database row map
  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
  // Convert integer value from the database to boolean
        isSyncedWithCloud =
        (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

  // Override toString, ==, and hashCode methods for easier debugging and comparison
  @override
  String toString() =>
      'Note, ID = $id, userId = $userId, isSyncedWithCloud = $isSyncedWithCloud, text = $text';

  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// Constants for table and column names
const dbName = 'notes.db';
const notesTable = 'notes';
const userTable = 'user';
const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'user_id';
const textColumn = 'text';
const isSyncedWithCloudColumn = 'is_synced_with_cloud';

// SQL statements to create user and notes tables if they don't exist
const createUserTable = ''' CREATE TABLE IF NOT EXISTS "user" (
	      "id"	INTEGER NOT NULL,
	      "email"	TEXT NOT NULL UNIQUE,
	      PRIMARY KEY("id" AUTOINCREMENT)
        );''';

const createNoteTable = ''' CREATE TABLE IF NOT EXISTS "notes" (
	      "id"	INTEGER NOT NULL,
	      "user_id"	INTEGER NOT NULL,
	      "text"	TEXT,
	      "is_synced_with_cloud"	INTEGER DEFAULT 0,
	      FOREIGN KEY("user_id") REFERENCES "user"("id"),
	      PRIMARY KEY("id" AUTOINCREMENT)
        ); ''';
