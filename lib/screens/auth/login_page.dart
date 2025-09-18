import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  // Email/password login
  Future<void> _loginEmail() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final err = await auth.signInWithEmail(_emailCtrl.text.trim(), _passwordCtrl.text);

    if (err != null) {
      _showError(err);
      return;
    }

    // Navigate once profile is ready
    if (auth.profile != null) {
      Navigator.pushReplacementNamed(context, '/preferences');
    } else {
      _showError("Login failed. Please try again.");
    }
  }

  // Google login
  Future<void> _loginGoogle() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final err = await auth.signInWithGoogle();

    if (err != null) {
      _showError(err);
      return;
    }

    if (auth.profile != null) {
      Navigator.pushReplacementNamed(context, '/preferences');
    } else {
      _showError("Login failed. Please try again.");
    }
  }

  void _showError(String m) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(m), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF81C784), Color(0xFFF1F8E9)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/logos/farmer_logo.png', height: 90),
                          const SizedBox(height: 12),
                          const Text('Welcome Back', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),

                          // Email
                          TextFormField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: const Icon(Icons.email, color: Color(0xFF4CAF50)),
                              filled: true,
                              fillColor: Colors.green.shade50,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            validator: (v) => v != null && v.contains('@') ? null : 'Enter valid email',
                          ),
                          const SizedBox(height: 14),

                          // Password
                          TextFormField(
                            controller: _passwordCtrl,
                            obscureText: _obscure,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock, color: Color(0xFF4CAF50)),
                              suffixIcon: IconButton(
                                icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                                onPressed: () => setState(() => _obscure = !_obscure),
                              ),
                              filled: true,
                              fillColor: Colors.green.shade50,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            validator: (v) => v != null && v.length >= 6 ? null : 'Password min 6 chars',
                          ),
                          const SizedBox(height: 18),

                          // Login button
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: auth.isLoading ? null : _loginEmail,
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4CAF50)),
                              child: auth.isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text('Login'),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Register
                          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            const Text("Don't have an account?"),
                            TextButton(
                              onPressed: () => Navigator.pushNamed(context, '/register'),
                              child: const Text('Register'),
                            ),
                          ]),
                          const SizedBox(height: 8),
                          const Divider(),
                          const SizedBox(height: 8),

                          // Google login
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              icon: Image.asset('assets/logos/google.png', width: 20, height: 20),
                              label: const Text('Sign in with Google'),
                              onPressed: auth.isLoading ? null : _loginGoogle,
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Forgot password
                          TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Forgot password flow coming soon')),
                              );
                            },
                            child: const Text('Forgot password?'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
