import 'package:notes_taking_app/service/auth/authExceptions.dart';
import 'package:notes_taking_app/service/auth/authProvider.dart';
import 'package:notes_taking_app/service/auth/authUser.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();

    // Test: Authentication provider should not be initialized initially
    test('Should not be initialized to begin with', () {
      expect(provider.isInitialized, false);
    });

    // Test: Attempting to log out without initialization should throw an exception
    test('Cannot log out if not initialized', () {
      expect(
        provider.logout(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });

    // Test: Authentication provider should be able to initialize
    test('Should be able to be initialized', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    // Test: After initialization, the current user should be null
    test('User should be null after initialization', () {
      expect(provider.currentUser, null);
    });

    // Test: Initialization should complete in less than 2 seconds
    test(
      'Should be able to initialize in less than 2 seconds',
          () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    // Test: Creating a user should delegate to the login function
    test('Create user should delegate to logIn function', () async {
      final badEmailUser = provider.createUser(
        email: 'foo@bar.com',
        password: 'anypassword',
      );
      expect(badEmailUser, throwsA(const TypeMatcher<UserNotFoundAuthExceptions>()));

      final badPasswordUser = provider.createUser(
        email: 'someone@bar.com',
        password: 'foobar',
      );
      expect(badPasswordUser, throwsA(const TypeMatcher<WrongPasswordAuthExceptions>()));

      final user = await provider.createUser(
        email: 'foo',
        password: 'bar',
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    // Test: A logged-in user should be able to get verified
    test('Logged in user should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    // Test: User should be able to log out and log in again
    test('Should be able to log out and log in again', () async {
      await provider.logout();
      await provider.login(
        email: 'email',
        password: 'password',
      );
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

// Exception class for not initialized provider
class NotInitializedException implements Exception {}

// Mock Authentication Provider implementing AuthProvider
class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return login(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'foo@bar.com') throw UserNotFoundAuthExceptions();
    if (password == 'foobar') throw WrongPasswordAuthExceptions();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logout() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthExceptions();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthExceptions();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }

  Future<void> sendPasswordReset({required String toEmail}) {
    throw UnimplementedError();
  }
}
