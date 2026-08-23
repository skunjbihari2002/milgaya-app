import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:milgaya/services/firebase_auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscurePassword = true;
  bool _agreedToTerms = false;
  bool _isLoading = false;
  bool _otpSent = false;
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkLocationPermission());
  }

  void _checkLocationPermission() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Enable Location'),
        content: const Text('Please turn on your GPS location to automatically fetch your City and State.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Deny', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: () { Navigator.pop(context); _autoFillLocation(); },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1976D2), foregroundColor: Colors.white),
            child: const Text('Turn On'),
          ),
        ],
      ),
    );
  }

  void _autoFillLocation() async {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fetching location...')));
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() { _cityController.text = 'Bhopal'; _stateController.text = 'MP'; });
    }
  }
  
  bool _validateFields() {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _phoneController.text.isEmpty || _passwordController.text.isEmpty) {
      _showError('Please fill in all required fields.');
      return false;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_emailController.text)) {
      _showError('Please enter a valid email address.');
      return false;
    }
    if (_phoneController.text.length < 10) {
      _showError('Please enter a valid 10-digit phone number.');
      return false;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      _showError('Passwords do not match.');
      return false;
    }
    if (!_agreedToTerms) {
      _showError('You must agree to the Terms of Service and Privacy Policy to continue.');
      return false;
    }
    return true;
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  void _handleSignUp() async {
    if (!_validateFields()) return;

    if (!_otpSent) {
      setState(() => _isLoading = true);
      
      // Call Firebase Auth Service
      await FirebaseAuthService().sendOTP(
        _phoneController.text,
        onSuccess: () {
          setState(() {
            _isLoading = false;
            _otpSent = true;
          });
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP sent to your phone!')));
        },
        onError: (error) {
          setState(() => _isLoading = false);
          _showError(error);
        }
      );
    } else {
      if (_otpController.text.length == 4 || _otpController.text.length == 6) { // Firebase can send 6-digit OTPs
        setState(() => _isLoading = true);
        
        await FirebaseAuthService().verifyOTP(
          _otpController.text,
          onSuccess: () async {
            // Once OTP is valid, create the Email/Password account
            await FirebaseAuthService().signUpWithEmail(
              _emailController.text, 
              _passwordController.text,
              onSuccess: () {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account created successfully! Please login.')));
                  context.go('/login');
                }
              },
              onError: (error) {
                setState(() => _isLoading = false);
                _showError("Phone verified, but Email Error: $error");
              }
            );
          },
          onError: (error) {
            setState(() => _isLoading = false);
            _showError(error);
          }
        );
      } else {
        _showError('Please enter a valid OTP.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: const Color(0xFF1976D2), elevation: 0, iconTheme: const IconThemeData(color: Colors.white)),
      body: Column(
        children: [
          Container(
            width: double.infinity, padding: const EdgeInsets.only(bottom: 24),
            decoration: const BoxDecoration(color: Color(0xFF1976D2)),
            child: const Column(
              children: [
                Icon(Icons.security, size: 40, color: Colors.white),
                SizedBox(height: 8),
                Text('Milgaya', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                Text('Join your community today', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Create Account', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 32),
                  
                  if (!_otpSent) ...[
                    _buildTextField(_nameController, 'Full Name *', Icons.person_outline),
                    const SizedBox(height: 16),
                    _buildTextField(_emailController, 'Email Address *', Icons.email_outlined, isEmail: true),
                    const SizedBox(height: 16),
                    _buildTextField(_phoneController, 'Phone Number *', Icons.phone_android, isPhone: true),
                    const SizedBox(height: 16),
                    
                    TextField(
                      controller: _passwordController, obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Password *', prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined), onPressed: () => setState(() => _obscurePassword = !_obscurePassword)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(_confirmPasswordController, 'Confirm Password *', Icons.security, isObscure: true),
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(flex: 2, child: _buildTextField(_cityController, 'City', Icons.location_on_outlined)),
                        const SizedBox(width: 16),
                        Expanded(flex: 1, child: _buildTextField(_stateController, 'State', null)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Checkbox(value: _agreedToTerms, onChanged: (val) => setState(() => _agreedToTerms = val ?? false), activeColor: const Color(0xFF1976D2)),
                        const Expanded(
                          child: Text.rich(TextSpan(text: 'I agree to the ', children: [
                            TextSpan(text: 'Terms of Service', style: TextStyle(color: Color(0xFF1976D2), fontWeight: FontWeight.bold)),
                            TextSpan(text: ' and '),
                            TextSpan(text: 'Privacy Policy', style: TextStyle(color: Color(0xFF1976D2), fontWeight: FontWeight.bold)),
                          ]), style: TextStyle(fontSize: 12)),
                        )
                      ],
                    ),
                  ] else ...[
                    // OTP Verification Step
                    const Text('Verification Required', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1976D2))),
                    const SizedBox(height: 8),
                    Text('We sent a 4-digit OTP to ${_phoneController.text}. Enter it below to verify your account.', style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 24),
                    _buildTextField(_otpController, 'Enter OTP', Icons.message, isPhone: true),
                  ],
                  
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSignUp,
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1976D2), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: _isLoading ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white)) : Text(_otpSent ? 'VERIFY & CREATE ACCOUNT' : 'SEND OTP', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String hint, IconData? icon, {bool isEmail = false, bool isPhone = false, bool isObscure = false}) {
    return TextField(
      controller: ctrl,
      obscureText: isObscure,
      keyboardType: isEmail ? TextInputType.emailAddress : (isPhone ? TextInputType.phone : TextInputType.text),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
