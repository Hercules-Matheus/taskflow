import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthException implements Exception {
  String message;
  AuthException(this.message);
}

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? localUser = FirebaseAuth.instance.currentUser;
  bool isLoading = true;

  AuthService() {
    _authCheck();
  }

  _authCheck() {
    _auth.authStateChanges().listen((User? user) {
      localUser = (user == null) ? null : user;
      isLoading = false;
      notifyListeners();
    });
  }

  _getUser() {
    localUser;
    notifyListeners();
  }

  signup(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _getUser();
    } on FirebaseAuthException catch (e) {
      debugPrint("error-code: ${e.code}");
      if (e.code == 'weak-password') {
        throw AuthException('A senha é muito fraca!');
      } else if (e.code == 'email-already-in-use') {
        throw AuthException('Este email já está cadastrado.');
      }
    }
  }

  signin(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _getUser();
    } on FirebaseAuthException catch (e) {
      debugPrint("error-code: ${e.code}");
      if (e.code == 'invalid-credential') {
        throw AuthException('Email ou senha incorreta');
      } else if (e.code == 'invalid-email') {
        throw AuthException('Email inválido.');
      }
    }
  }

  logout() async {
    await _auth.signOut();
    _getUser();
  }
}
