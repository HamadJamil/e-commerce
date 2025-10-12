import 'package:e_commerce/core/providers/auth_provider.dart';
import 'package:e_commerce/shared/widgets/snack_bar_helper.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final authProvider = context.read<AuthenticationProvider>();
      await authProvider.signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (authProvider.isEmailVerified) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _showVerificationDialog(authProvider);
      }
    } catch (e) {
      SnackbarHelper.error(
        context: context,
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  void _showVerificationDialog(AuthenticationProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Email Not Verified'),
        content: Text(
          'Please verify your email address before logging in. '
          'Check your inbox for the verification email.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await authProvider.sendEmailVerification();
                SnackbarHelper.success(
                  context: context,
                  title: 'Success',
                  message: 'Verification email sent!',
                );
              } catch (e) {
                SnackbarHelper.error(
                  context: context,
                  title: 'Error',
                  message: e.toString(),
                );
              }
            },
            child: Text('Resend Email'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                LottieBuilder.asset(
                  'assets/logo.json',
                  width: 200,
                  height: 200,
                  repeat: false,
                ),
                SizedBox(height: 20),
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 32),
                TextFormField(
                  focusNode: _emailFocusNode,
                  onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Please enter email';
                    if (!value!.contains('@')) {
                      return 'Please enter valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  focusNode: _passwordFocusNode,
                  onFieldSubmitted: (_) => _login(),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Please enter password';
                    return null;
                  },
                ),
                Align(
                  alignment: AlignmentGeometry.centerRight,
                  child: TextButton(
                    onPressed: authProvider.isLoading
                        ? null
                        : () {
                            _showForgotPasswordDialog();
                          },
                    child: Text('Forgot Password?'),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: authProvider.isLoading ? null : _login,
                    child: authProvider.isLoading
                        ? LoadingAnimationWidget.stretchedDots(
                            color: Colors.black,
                            size: 20,
                          )
                        : Text('Login'),
                  ),
                ),
                SizedBox(height: 32),
                const Row(
                  children: [
                    Expanded(child: Divider(thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('OR'),
                    ),
                    Expanded(child: Divider(thickness: 1)),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account? '),
                    TextButton(
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      onPressed: authProvider.isLoading
                          ? null
                          : () {
                              Navigator.pushReplacementNamed(
                                context,
                                '/signup',
                              );
                            },
                      child: Text('Sign Up'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reset Password'),
        content: TextFormField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'Enter your email address',
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Please enter email';
            if (!value!.contains('@')) return 'Please enter valid email';
            return null;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (emailController.text.isNotEmpty &&
                  emailController.text.contains('@')) {
                Navigator.pop(context);
                try {
                  final authProvider = context.read<AuthenticationProvider>();
                  await authProvider.sendPasswordResetEmail(
                    emailController.text.trim(),
                  );
                  SnackbarHelper.success(
                    context: context,
                    title: 'Success',
                    message: 'Password reset email sent!',
                  );
                } catch (e) {
                  SnackbarHelper.error(
                    context: context,
                    title: 'Error',
                    message: e.toString(),
                  );
                }
              }
            },
            child: Text('Send Reset Link'),
          ),
        ],
      ),
    );
  }
}
