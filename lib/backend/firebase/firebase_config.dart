import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBqGmzXlXhobpiScAOVfhPKHB4UcpNOkoQ",
            authDomain: "gaiatorch.firebaseapp.com",
            projectId: "gaiatorch",
            storageBucket: "gaiatorch.firebasestorage.app",
            messagingSenderId: "873879862724",
            appId: "1:873879862724:web:1818b32f85a713612f7891",
            measurementId: "G-2XNLHPE863"));
  } else {
    await Firebase.initializeApp();
  }
}
