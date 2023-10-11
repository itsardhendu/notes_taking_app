import 'package:firebase_core/firebase_core.dart';
import 'package:notes_taking_app/service/auth/authProvider.dart';
import 'package:notes_taking_app/service/auth/authUser.dart';
import 'package:notes_taking_app/service/auth/authExceptions.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;

import '../../firebase_options.dart';

class FirebaseAuthProvider implements AuthProvider {
  // Initialize Firebase when the provider is instantiated
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      // Create user with email and password using Firebase authentication
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Retrieve and return the current user
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase authentication exceptions
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthExceptions();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthExceptions();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthExceptions();
      } else {
        throw GenericAuthExceptions();
      }
    } catch (_) {
      // Catch any other exceptions and throw a generic authentication exception
      throw GenericAuthExceptions();
    }
  }

  @override
  AuthUser? get currentUser {
    // Retrieve the current user from Firebase authentication
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    try {
      // Sign in user with email and password using Firebase authentication
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Retrieve and return the current user
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase authentication exceptions
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthExceptions();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthExceptions();
      } else {
        throw GenericAuthExceptions();
      }
    } catch (_) {
      // Catch any other exceptions and throw a generic authentication exception
      throw GenericAuthExceptions();
    }
  }

  @override
  Future<void> logout() async {
    // Sign out the current user from Firebase authentication
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    // Send email verification to the current user using Firebase authentication
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotFoundAuthExceptions();
    }
  }
}
