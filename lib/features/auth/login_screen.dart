import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  bool _isOtpLogin = false; // Toggle between Password and OTP
  bool _otpSent = false; // State to show OTP input field
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  void _handleLogin() {
    // Admin Check
    if (!_isOtpLogin && _emailController.text == '7880058485' && _passwordController.text == '7880058485') {
      context.go('/admin');
      return;
    }

    // Normal User Password Login
    if (!_isOtpLogin) {
      if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
        context.go('/');
      } else {
        _showError('Please enter Email/ID and Password, or Sign Up first.');
      }
    } 
    // Normal User OTP Login
    else {
      if (_otpSent) {
        if (_otpController.text == '1234') { // Mock OTP Verification
          context.go('/');
        } else {
          _showError('Invalid OTP. Please try again. (Hint: use 1234)');
        }
      } else {
        if (_phoneController.text.length >= 10) {
          setState(() {
            _otpSent = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP sent to your mobile!')));
        } else {
          _showError('Please enter a valid 10-digit mobile number.');
        }
      }
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top Blue Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 30),
            decoration: const BoxDecoration(color: Color(0xFF1976D2)),
            child: Column(
              children: [
                Container(
                  width: 70, height: 70,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.security, size: 35, color: Color(0xFF1976D2)),
                ),
                const SizedBox(height: 12),
                const Text('Milgaya', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                const Text('Smart Lost & Found Ecosystem', style: TextStyle(fontSize: 14, color: Colors.white70)),
              ],
            ),
          ),
          
          // Toggle Buttons (Password vs OTP)
          Container(
            color: Colors.grey.shade100,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() { _isOtpLogin = false; _otpSent = false; }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: !_isOtpLogin ? const Color(0xFF1976D2) : Colors.transparent, width: 3)),
                      ),
                      child: Text('Login with Password', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: !_isOtpLogin ? const Color(0xFF1976D2) : Colors.grey)),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() { _isOtpLogin = true; }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: _isOtpLogin ? const Color(0xFF1976D2) : Colors.transparent, width: 3)),
                      ),
                      child: Text('Login with OTP', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: _isOtpLogin ? const Color(0xFF1976D2) : Colors.grey)),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Form Section
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_isOtpLogin ? 'Quick Access' : 'Welcome back', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                  const SizedBox(height: 8),
                  Text(_isOtpLogin ? 'Verify your mobile number' : 'Sign in to your account', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 32),
                  
                  if (!_isOtpLogin) ...[
                    // --- PASSWORD LOGIN FLOW ---
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Email address or User ID',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Reset Password'),
                                content: const TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Enter your Email / Mobile',
                                    prefixIcon: Icon(Icons.email),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Password reset link/OTP sent!')),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1976D2), foregroundColor: Colors.white),
                                    child: const Text('Send Reset Link'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text('Forgot Password?', style: TextStyle(color: Color(0xFF1976D2))),
                      ),
                    ),
                  ] else ...[
                    // --- OTP LOGIN FLOW ---
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      readOnly: _otpSent, // Lock number once OTP is sent
                      decoration: InputDecoration(
                        hintText: 'Mobile Number',
                        prefixIcon: const Icon(Icons.phone_android),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_otpSent) ...[
                      TextField(
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        decoration: InputDecoration(
                          hintText: 'Enter 4-digit OTP',
                          prefixIcon: const Icon(Icons.message),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ],
                  
                  const SizedBox(height: 16),
                  
                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        !_isOtpLogin ? 'LOG IN' : (_otpSent ? 'VERIFY & LOGIN' : 'SEND OTP'),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Social Login Section
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey.shade300)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('Or continue with', style: TextStyle(color: Colors.grey)),
                      ),
                      Expanded(child: Divider(color: Colors.grey.shade300)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton(Icons.g_mobiledata, 'Google'), // Google
                      const SizedBox(width: 20),
                      _buildSocialButton(Icons.facebook, 'Facebook'),     // Facebook
                      const SizedBox(width: 20),
                      _buildSocialButton(Icons.apple, 'Apple'),        // Apple
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? ", style: TextStyle(color: Colors.grey)),
                      GestureDetector(
                        onTap: () => context.push('/signup'),
                        child: const Text('Sign Up', style: TextStyle(color: Color(0xFF1976D2), fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String providerName) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 28, color: const Color(0xFF1A1A1A)),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logged in securely via $providerName!')));
          // After social auth, navigate to home
          context.go('/');
        },
      ),
    );
  }
}
