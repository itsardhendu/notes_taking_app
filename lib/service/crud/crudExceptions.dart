// Custom exception to handle cases when the database is already open
class DatabaseAlreadyOpenException implements Exception {
  @override
  String toString() => 'Database is already open.';
}

// Custom exception to handle cases when unable to get the documents directory
class UnableToGetDocumentsDirectory implements Exception {
  @override
  String toString() => 'Unable to get the documents directory.';
}

// Custom exception to handle cases when the database is not open
class DatabaseIsNotOpen implements Exception {
  @override
  String toString() => 'Database is not open.';
}

// Custom exception to handle cases when could not delete a user
class CouldNotDeleteUser implements Exception {
  @override
  String toString() => 'Could not delete the user.';
}

// Custom exception to handle cases when a user already exists
class UserAlreadyExists implements Exception {
  @override
  String toString() => 'User already exists.';
}

// Custom exception to handle cases when a user cannot be found
class CouldNotFindUser implements Exception {
  @override
  String toString() => 'Could not find the user.';
}

// Custom exception to handle cases when could not delete a note
class CouldNotDeleteNote implements Exception {
  @override
  String toString() => 'Could not delete the note.';
}

// Custom exception to handle cases when a note cannot be found
class CouldNotFindNote implements Exception {
  @override
  String toString() => 'Could not find the note.';
}

// Custom exception to handle cases when could not update a note
class CouldNotUpdateNote implements Exception {
  @override
  String toString() => 'Could not update the note.';
}
