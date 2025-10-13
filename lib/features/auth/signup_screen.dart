import 'package:e_commerce/core/providers/auth_provider.dart';
import 'package:e_commerce/core/theme/text_style_helper.dart';
import 'package:e_commerce/shared/widgets/snack_bar_helper.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _nameController;
  bool _isLoading = false;
  bool _isChecked = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  late FocusNode _nameFocusNode;
  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;
  late FocusNode _confirmPasswordFocusNode;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _nameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Account',
                  style: Theme.of(
                    context,
                  ).textTheme.headline4?.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  'Create a new account to get started and \nenjoy our app!',
                  style: TextStyleHelper.bodyMedium(context),
                ),
                SizedBox(height: 32),
                TextFormField(
                  focusNode: _nameFocusNode,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  onFieldSubmitted: (_) => _emailFocusNode.requestFocus(),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Please enter name';
                    if (value!.length < 3 || value.length > 30) {
                      return 'Name must be between 3 and 30 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  focusNode: _emailFocusNode,
                  onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
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
                  onFieldSubmitted: (_) =>
                      _confirmPasswordFocusNode.requestFocus(),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
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
                    if (value?.isEmpty ?? true) {
                      return 'Please enter password';
                    }
                    if (value!.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  focusNode: _confirmPasswordFocusNode,
                  onFieldSubmitted: (_) => _signUp(),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isConfirmPasswordVisible,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please confirm password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Checkbox(
                      value: _isChecked,
                      onChanged: (value) {
                        setState(() {
                          _isChecked = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyleHelper.bodyMedium(context),
                          children: [
                            const TextSpan(text: 'I accept the '),
                            TextSpan(
                              text: 'Terms & Conditions',
                              style: TextStyleHelper.bodyMedium(context)
                                  ?.copyWith(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyleHelper.bodyMedium(context)
                                  ?.copyWith(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signUp,
                    child: _isLoading
                        ? LoadingAnimationWidget.stretchedDots(
                            color: Colors.black,
                            size: 20,
                          )
                        : Text('Create Account'),
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
                    Text('Already have an account? '),
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                      child: Text('Login'),
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

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final authProvider = context.read<AuthenticationProvider>();
      await authProvider.signUp(
        _emailController.text.trim(),
        _passwordController.text,
        _nameController.text.trim(),
      );

      SnackbarHelper.info(
        context: context,
        title: 'Success',
        message: 'Verification email sent! Please check your email.',
      );

      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      SnackbarHelper.error(
        context: context,
        title: 'Error',
        message: 'Sign up failed: ${e.toString()}',
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
