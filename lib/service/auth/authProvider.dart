import 'package:notes_taking_app/service/auth/authUser.dart';

// Abstract class for authentication providers
abstract class AuthProvider {
  // Get the currently authenticated user, if any
  AuthUser? get currentUser;

  // Authenticate a user with email and password
  Future<AuthUser> login({
    required String email,
    required String password,
  });

  // Create a new user with email and password
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });

  // Log out the currently authenticated user
  Future<void> logout();

  // Send email verification to the authenticated user
  Future<void> sendEmailVerification();

  // Initialize the authentication provider
  initialize() {}
}
