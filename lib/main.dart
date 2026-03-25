 import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'services/firestore_service.dart';
import 'views/calculator_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String? startupError;

  try {
    await Firebase.initializeApp();
    await FirestoreService.instance.ensureAuthenticated();
  } catch (e) {
    startupError = e.toString();
  }

  runApp(CalculatorApp(startupError: startupError));
}

class CalculatorApp extends StatelessWidget {
  final String? startupError;

  const CalculatorApp({super.key, this.startupError});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1C1C1E),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF9500),
          secondary: Color(0xFFFF9500),
          surface: Color(0xFF1C1C1E),
        ),
      ),
      home: startupError == null
          ? const CalculatorView()
          : FirebaseSetupErrorView(errorMessage: startupError!),
    );
  }
}

class FirebaseSetupErrorView extends StatelessWidget {
  final String errorMessage;

  const FirebaseSetupErrorView({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase setup required'),
        backgroundColor: const Color(0xFF1C1C1E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'The app code is ready, but Firebase is not configured on this machine yet.',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            const Text(
              'To finish setup:',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 12),
            const Text(
              '1. Add your Android app to Firebase.\n'
              '2. Place google-services.json inside android/app/.\n'
              '3. Enable Firestore Database.\n'
              '4. Enable Anonymous Authentication.\n'
              '5. Run the app again.',
              style: TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
