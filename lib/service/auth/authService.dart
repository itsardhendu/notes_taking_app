import 'package:notes_taking_app/service/auth/authProvider.dart';
import 'package:notes_taking_app/service/auth/authUser.dart';
import 'package:notes_taking_app/service/auth/firebaseAuthProvider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;

  // Constructor to initialize the AuthService with a specific authentication provider
  const AuthService(this.provider);

  // Factory constructor to create an instance of AuthService with a Firebase authentication provider
  factory AuthService.firebase() => AuthService(
    FirebaseAuthProvider(),
  );

  // Implementation of the AuthProvider interface methods

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(
        email: email,
        password: password,
      );

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) =>
      provider.login(
        email: email,
        password: password,
      );

  @override
  Future<void> logout() => provider.logout();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initialize() => provider.initialize();
}
