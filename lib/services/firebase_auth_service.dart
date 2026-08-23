import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class FirebaseAuthService {
  static final FirebaseAuthService _instance = FirebaseAuthService._internal();
  factory FirebaseAuthService() => _instance;
  FirebaseAuthService._internal();

  String? _verificationId;

  // Real OTP Send via Firebase
  Future<void> sendOTP(String phoneNumber, {required Function() onSuccess, required Function(String) onError}) async {
    try {
      // Check if Firebase is actually configured to prevent crashing before the user sets it up
      if (Firebase.apps.isEmpty) {
        // Fallback to mock for now since backend is not connected
        debugPrint("FIREBASE NOT CONFIGURED: Falling back to Mock OTP.");
        await Future.delayed(const Duration(seconds: 2));
        onSuccess();
        return;
      }

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber.startsWith('+') ? phoneNumber : '+91$phoneNumber', // Default to India +91
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-resolution (Android only)
          await FirebaseAuth.instance.signInWithCredential(credential);
          onSuccess();
        },
        verificationFailed: (FirebaseAuthException e) {
          onError(e.message ?? 'Verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          onSuccess();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      onError(e.toString());
    }
  }

  // Verify the OTP code
  Future<void> verifyOTP(String otp, {required Function() onSuccess, required Function(String) onError}) async {
    try {
       if (Firebase.apps.isEmpty) {
        // Fallback to mock
        if (otp == '1234') { // Accept 1234 in Mock mode
          await Future.delayed(const Duration(seconds: 2));
          onSuccess();
        } else {
          onError("Invalid Mock OTP. Use 1234.");
        }
        return;
      }

      if (_verificationId == null) {
        onError("OTP Request not found. Please resend.");
        return;
      }

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      onSuccess();
    } catch (e) {
      onError("Invalid OTP or expired.");
    }
  }
}
