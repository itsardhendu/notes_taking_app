import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/cupertino.dart';

// Immutable class representing an authenticated user
@immutable
class AuthUser {
  final bool isEmailVerified;

  // Constructor to create an AuthUser instance with email verification status
  const AuthUser({required this.isEmailVerified});

  // Factory method to create an AuthUser instance from a Firebase User object
  factory AuthUser.fromFirebase(User user) =>
      AuthUser(isEmailVerified: user.emailVerified);
}
