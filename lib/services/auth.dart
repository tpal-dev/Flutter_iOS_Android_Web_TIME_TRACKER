import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthBase {
  User get currentUser;
  Stream<User> authStateChanges();
  Future<User> signInAnonymously();
  Future<User> signInWithEmailAndPassword({String email, String password});
  Future<User> createUserWithEmailAndPassword({String email, String password});
  Future<void> resetPassword({String email});
  Future<User> signInWithFacebook();
  Future<User> signInWithGoogle();
  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  @override
  Stream<User> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  User get currentUser => _firebaseAuth.currentUser;

  @override
  Future<User> signInAnonymously() async {
    try {
      final UserCredential userCredential = await _firebaseAuth.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      print('Error -> Exception details:\n $e');
      rethrow;
    }
  }

  @override
  Future<User> signInWithEmailAndPassword({String email, String password}) async {
    final userCredential = await _firebaseAuth
        .signInWithCredential(EmailAuthProvider.credential(email: email, password: password));
    return userCredential.user;
  }

  @override
  Future<User> createUserWithEmailAndPassword({String email, String password}) async {
    final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  @override
  Future<void> resetPassword({String email}) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<User> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login(
      permissions: [
        'public_profile',
        'email',
        // 'pages_show_list',
        // 'pages_messaging',
        // 'pages_manage_metadata'
      ],
    );
    switch (result.status) {
      case LoginStatus.success:
        final AccessToken accessToken = result.accessToken;
        final userCredential = await _firebaseAuth
            .signInWithCredential(FacebookAuthProvider.credential(accessToken.token));
        return userCredential.user;
      case LoginStatus.cancelled:
        throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      case LoginStatus.failed:
        throw FirebaseAuthException(
          code: 'ERROR_FACEBOOK_LOGIN_FAILED',
          message: result.message,
        );
      default:
        throw UnimplementedError();
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        if (googleAuth.idToken != null) {
          final UserCredential userCredential = await _firebaseAuth.signInWithCredential(
              GoogleAuthProvider.credential(
                  idToken: googleAuth.idToken, accessToken: googleAuth.accessToken));
          return userCredential.user;
        } else {
          throw FirebaseAuthException(
            code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
            message: 'Missing Google ID Token',
          );
        }
      } else {
        throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      }
    } catch (e) {
      print('Error -> Exception details:\n $e');
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      final signInGoogle = await _googleSignIn.isSignedIn();
      if (signInGoogle) {
        await _googleSignIn.signOut();
      }
      final AccessToken accessTokenFacebook = await FacebookAuth.instance.accessToken;
      if (accessTokenFacebook != null) {
        await FacebookAuth.instance.logOut();
      }
      await _firebaseAuth.signOut();
    } catch (e) {
      print('Error -> Exception details:\n $e');
      rethrow;
    }
  }
}
