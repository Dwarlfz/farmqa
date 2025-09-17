// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? user;
  UserModel? profile;

  AuthProvider() {
    // Listen to auth state
    _auth.authStateChanges().listen((u) async {
      user = u;
      if (u != null) {
        await _loadUserProfile(u.uid);
      } else {
        profile = null;
      }
      notifyListeners();
    });
  }

  // Load profile from Firestore
  Future<void> _loadUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      profile = UserModel.fromDoc(doc);
    }
  }

  // Save new user to Firestore
  Future<void> _createUserProfile(User user) async {
    final docRef = _firestore.collection('users').doc(user.uid);
    final doc = await docRef.get();
    if (!doc.exists) {
      final newUser = UserModel(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName ?? "Farmer",
        phoneNumber: user.phoneNumber,
        createdAt: DateTime.now(),
      );
      await docRef.set(newUser.toMap());
      profile = newUser;
    }
  }

  // Email/password login
  Future<String?> signInWithEmail(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _createUserProfile(cred.user!);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Google Sign-In
  Future<String?> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return "Google Sign-In canceled";

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final cred = await _auth.signInWithCredential(credential);
      await _createUserProfile(cred.user!);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Register new user (email/password)
  Future<String?> registerWithEmail(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _createUserProfile(cred.user!);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
    user = null;
    profile = null;
    notifyListeners();
  }
}
