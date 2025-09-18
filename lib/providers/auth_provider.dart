// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? user; // Firebase user
  UserModel? profile; // App user profile
  bool isLoading = true; // Tracks loading state
  String? errorMessage; // Latest auth error

  AuthProvider() {
    // Listen to auth state changes
    _auth.authStateChanges().listen((u) async {
      isLoading = true;
      notifyListeners();

      user = u;
      if (u != null) {
        await _createOrLoadProfile(u);
      } else {
        profile = null;
      }

      isLoading = false;
      notifyListeners();
    });
  }

  // --------------------- Private Methods ---------------------

  // Load profile from Firestore
  Future<void> _loadUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      profile = doc.exists ? UserModel.fromDoc(doc) : null;
    } catch (e) {
      profile = null;
      debugPrint("Error loading user profile: $e");
    }
  }

  // Create profile if not exists, or load existing
  Future<void> _createOrLoadProfile(User user) async {
    try {
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
      } else {
        profile = UserModel.fromDoc(doc);
      }
    } catch (e) {
      profile = null;
      debugPrint("Error creating/loading user profile: $e");
    }
  }

  // --------------------- Public Methods ---------------------

  // Email/password login
  Future<String?> signInWithEmail(String email, String password) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Ensure profile is loaded
      await _createOrLoadProfile(cred.user!);

      return null; // Success
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
      return e.message;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Google Sign-In
  Future<String?> signInWithGoogle() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return "Google Sign-In canceled";

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final cred = await _auth.signInWithCredential(credential);

      // Ensure profile is loaded
      await _createOrLoadProfile(cred.user!);

      return null;
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
      return e.message;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Register new user (email/password)
  Future<String?> registerWithEmail(String email, String password) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Ensure profile is loaded
      await _createOrLoadProfile(cred.user!);

      return null; // Success
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
      return e.message;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Sign out
  Future<void> signOut() async {
    isLoading = true;
    notifyListeners();

    try {
      await _auth.signOut();
      await GoogleSignIn().signOut();
      user = null;
      profile = null;
    } catch (e) {
      debugPrint("Error signing out: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
