// consistify_frontend/lib/presentation/pages/auth/register_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consistify/core/util/input_validator.dart';
import 'package:consistify/presentation/blocs/auth/auth_bloc.dart';
import 'package:consistify/presentation/widgets/app_text_field.dart';
import 'package:consistify/presentation/widgets/loading_indicator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _notificationTimeController = TextEditingController(text: '18:00'); // Default 6 PM

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _notificationTimeController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _notificationTimeController.text = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  void _onRegisterPressed() {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        RegisterEvent(
          email: _emailController.text,
          username: _usernameController.text,
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
          notificationTime: _notificationTimeController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthRegistered) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registration successful! Please login.')),
            );
            Navigator.of(context).pushReplacementNamed('/login');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const LoadingIndicator();
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AppTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: InputValidator.validateEmail,
                  ),
                  const SizedBox(height: 16.0),
                  AppTextField(
                    controller: _usernameController,
                    labelText: 'Username',
                    validator: InputValidator.validateUsername,
                  ),
                  const SizedBox(height: 16.0),
                  AppTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    obscureText: true,
                    validator: InputValidator.validatePassword,
                  ),
                  const SizedBox(height: 16.0),
                  AppTextField(
                    controller: _confirmPasswordController,
                    labelText: 'Confirm Password',
                    obscureText: true,
                    validator: (val) => InputValidator.validateConfirmPassword(_passwordController.text, val),
                  ),
                  const SizedBox(height: 16.0),
                  GestureDetector(
                    onTap: () => _selectTime(context),
                    child: AbsorbPointer(
                      child: AppTextField(
                        controller: _notificationTimeController,
                        labelText: 'Notification Time (HH:MM)',
                        validator: InputValidator.validateNotificationTime,
                        readOnly: true, // Make it read-only to force time picker
                        suffixIcon: const Icon(Icons.access_time),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onRegisterPressed,
                      child: const Text('Register'),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text("Already have an account? Login"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}