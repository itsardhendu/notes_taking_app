// Exception to handle cases when the user is not found during authentication
class UserNotFoundAuthExceptions implements Exception {
  @override
  String toString() => 'User not found.';
}

// Exception to handle cases when the provided password is incorrect during authentication
class WrongPasswordAuthExceptions implements Exception {
  @override
  String toString() => 'Incorrect password.';
}

// Exception to handle cases when the provided password is weak during registration
class WeakPasswordAuthExceptions implements Exception {
  @override
  String toString() => 'Password is too weak.';
}

// Exception to handle cases when the provided email is already in use during registration
class EmailAlreadyInUseAuthExceptions implements Exception {
  @override
  String toString() => 'Email is already in use.';
}

// Exception to handle cases when the provided email is invalid during registration
class InvalidEmailAuthExceptions implements Exception {
  @override
  String toString() => 'Invalid email address.';
}

// Generic exception for authentication-related errors
class GenericAuthExceptions implements Exception {
  @override
  String toString() => 'Authentication error.';
}

// Exception to handle cases when the user is not logged in
class UserNotLoggedInAuthException implements Exception {
  @override
  String toString() => 'User is not logged in.';
}
