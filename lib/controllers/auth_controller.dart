import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async => await _auth.signOut();

  String getUserRole(String? email) {
    if (email == 'admin@test.com') return 'admin';
    if (email == 'operator@test.com') return 'operator';
    return 'guest';
  }

  bool canEdit(String role) => role == 'admin';
  bool canDelete(String role) => role == 'admin';
  bool canCreate(String role) => role == 'admin' || role == 'operator';
}