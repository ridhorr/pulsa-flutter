// pages/login_page.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_page.dart';
import 'order_history_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _isCheckingLogin = true;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _checkIfLoggedIn() async {
    setState(() {
      _isCheckingLogin = true;
    });

    final isLoggedIn = await _authService.isLoggedIn();

    if (!mounted) return;
    setState(() {
      _isCheckingLogin = false;
    });

    if (isLoggedIn) {
      Navigator.of(context).pushReplacementNamed('/order-history');
    }
  }

  void _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showError('Email dan password harus diisi');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      bool loginSuccess = false;
      
      if (email == "ridhorr2004@gmail.com" && password == "R1zky*2004") {
        loginSuccess = true;
      } else {
        loginSuccess = await _authService.login(email, password);
      }

      if (!mounted) return;

      if (loginSuccess) {
        Navigator.of(context).pushReplacementNamed('/order-history');
      } else {
        _showError('Email atau password salah. Silakan coba lagi.');
        // Tetap di halaman login, tidak redirect ke home
      }
    } catch (e) {
      if (mounted) {
        _showError('Terjadi kesalahan saat login: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFD32F2F),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingLogin) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFD32F2F),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      // Tambahkan AppBar dengan tombol back
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xFFD32F2F),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20), // Dikurangi karena ada AppBar
                
                // Logo/Title
                const Text(
                  'SRC IMRON',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD32F2F),
                    letterSpacing: 1,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'Masuk ke akun Anda',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                ),
                
                const SizedBox(height: 48),

                // Login Form
                Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: Color(0xFFD32F2F),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFD32F2F),
                              width: 2,
                            ),
                          ),
                          labelStyle: TextStyle(color: Colors.grey[600]),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),

                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(
                            Icons.lock_outlined,
                            color: Color(0xFFD32F2F),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.grey[600],
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFD32F2F),
                              width: 2,
                            ),
                          ),
                          labelStyle: TextStyle(color: Colors.grey[600]),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),

                      // Login Button
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _signIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD32F2F),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            disabledBackgroundColor: Colors.grey[300],
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Masuk',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}