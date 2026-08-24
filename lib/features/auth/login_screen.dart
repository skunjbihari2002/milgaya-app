import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:milgaya/services/firebase_auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  bool _isOtpLogin = false;
  bool _otpSent = false;
  bool _isLoading = false;
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  void _handleLogin() async {
    // Admin Check
    if (!_isOtpLogin && _emailController.text == '7880058485' && _passwordController.text == '7880058485') {
      context.go('/admin');
      return;
    }

    if (!_isOtpLogin) {
      if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
        setState(() => _isLoading = true);
        await FirebaseAuthService().loginWithEmail(
          _emailController.text,
          _passwordController.text,
          onSuccess: () {
            if (mounted) {
              setState(() => _isLoading = false);
              context.go('/');
            }
          },
          onError: (error) {
            setState(() => _isLoading = false);
            _showError(error);
          }
        );
      } else {
        _showError('Please enter valid Email/ID and Password.');
      }
    } else {
      if (_otpSent) {
        if (_otpController.text.length == 4 || _otpController.text.length == 6) {
          setState(() => _isLoading = true);
          await FirebaseAuthService().verifyOTP(
            _otpController.text,
            onSuccess: () {
              if (mounted) {
                setState(() => _isLoading = false);
                context.go('/');
              }
            },
            onError: (error) {
              setState(() => _isLoading = false);
              _showError(error);
            }
          );
        } else {
          _showError('Please enter a valid OTP.');
        }
      } else {
        if (_phoneController.text.length >= 10) {
          setState(() => _isLoading = true);
          await FirebaseAuthService().sendOTP(
            _phoneController.text,
            onSuccess: () {
              setState(() {
                _isLoading = false;
                _otpSent = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP sent successfully!')));
            },
            onError: (error) {
              setState(() => _isLoading = false);
              _showError(error);
            }
          );
        } else {
          _showError('Please enter a valid 10-digit mobile number.');
        }
      }
    }
  }

  void _simulateLoading(VoidCallback onSuccess) async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isLoading = false);
      onSuccess();
    }
  }

  void _simulateSocialLogin(String provider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 24),
            Text('Connecting to $provider...'),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pop(context); // Close dialog
        // Prevent bypassing. Show error since OAuth keys aren't configured yet.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Authentication Failed: $provider OAuth keys not configured on backend.'),
            backgroundColor: Colors.red,
          )
        );
      }
    });
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  void _handleForgotPassword() {
    showDialog(
      context: context,
      builder: (context) {
        final resetCtrl = TextEditingController();
        bool isSending = false;
        
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Reset Password'),
              content: TextField(
                controller: resetCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'Enter registered Email', prefixIcon: Icon(Icons.email)),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
                ElevatedButton(
                  onPressed: isSending ? null : () async {
                    if (resetCtrl.text.isEmpty || !resetCtrl.text.contains('@')) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid email address'), backgroundColor: Colors.red));
                      return;
                    }
                    
                    setDialogState(() => isSending = true);
                    await FirebaseAuthService().resetPassword(
                      resetCtrl.text.trim(),
                      onSuccess: () {
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password reset link sent to your email!')));
                        }
                      },
                      onError: (error) {
                        if (context.mounted) {
                          setDialogState(() => isSending = false);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error), backgroundColor: Colors.red));
                        }
                      }
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1976D2), foregroundColor: Colors.white),
                  child: isSending ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Send Link'),
                ),
              ],
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true, // Only scroll if keyboard pushes it up
      body: SafeArea(
        child: Column(
          children: [
            // Top Blue Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
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
            
            // Toggle Buttons
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() { _isOtpLogin = false; _otpSent = false; }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: !_isOtpLogin ? const Color(0xFF1976D2) : Colors.transparent, width: 3))),
                      child: Text('Login with Password', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: !_isOtpLogin ? const Color(0xFF1976D2) : Colors.grey)),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() { _isOtpLogin = true; }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: _isOtpLogin ? const Color(0xFF1976D2) : Colors.transparent, width: 3))),
                      child: Text('Login with OTP', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: _isOtpLogin ? const Color(0xFF1976D2) : Colors.grey)),
                    ),
                  ),
                ),
              ],
            ),

            // Form Section (Flexible to fit screen without scrolling if possible)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                physics: const ClampingScrollPhysics(), // No bouncy scrolling, acts fixed unless keyboard is up
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(_isOtpLogin ? 'Quick Access' : 'Welcome back', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 24),
                    
                    if (!_isOtpLogin) ...[
                      TextField(controller: _emailController, decoration: InputDecoration(hintText: 'Email address or User ID', prefixIcon: const Icon(Icons.person_outline), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController, obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: 'Password', prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined), onPressed: () => setState(() => _obscurePassword = !_obscurePassword)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(onPressed: _handleForgotPassword, child: const Text('Forgot Password?', style: TextStyle(color: Color(0xFF1976D2)))),
                      ),
                    ] else ...[
                      TextField(controller: _phoneController, keyboardType: TextInputType.phone, readOnly: _otpSent, decoration: InputDecoration(hintText: 'Mobile Number', prefixIcon: const Icon(Icons.phone_android), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
                      const SizedBox(height: 16),
                      if (_otpSent)
                        TextField(controller: _otpController, keyboardType: TextInputType.number, maxLength: 4, decoration: InputDecoration(hintText: 'Enter 4-digit OTP', prefixIcon: const Icon(Icons.message), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
                    ],
                    
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1976D2), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        child: _isLoading ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white)) : Text(!_isOtpLogin ? 'LOG IN' : (_otpSent ? 'VERIFY & LOGIN' : 'SEND OTP'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    const Row(children: [Expanded(child: Divider()), Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Or continue with', style: TextStyle(color: Colors.grey))), Expanded(child: Divider())]),
                    const SizedBox(height: 24),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialButton(Icons.g_mobiledata, 'Google'),
                        const SizedBox(width: 20),
                        _buildSocialButton(Icons.facebook, 'Facebook'),
                        const SizedBox(width: 20),
                        _buildSocialButton(Icons.apple, 'Apple'),
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? ", style: TextStyle(color: Colors.grey)),
                        GestureDetector(onTap: () => context.push('/signup'), child: const Text('Sign Up', style: TextStyle(color: Color(0xFF1976D2), fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String provider) {
    return Container(
      width: 50, height: 50,
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade300), color: Colors.white),
      child: IconButton(
        icon: Icon(icon, size: 28, color: const Color(0xFF1A1A1A)),
        onPressed: () => _simulateSocialLogin(provider),
      ),
    );
  }
}
