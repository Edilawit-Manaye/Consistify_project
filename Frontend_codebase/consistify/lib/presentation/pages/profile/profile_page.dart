// consistify_frontend/lib/presentation/pages/profile/profile_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consistify/core/constants/app_constants.dart';
import 'package:consistify/core/util/input_validator.dart';
import 'package:consistify/domain/entities/user.dart';
import 'package:consistify/presentation/blocs/auth/auth_bloc.dart';
import 'package:consistify/presentation/widgets/app_text_field.dart';
import 'package:consistify/presentation/widgets/loading_indicator.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _notificationTimeController;
  final Map<String, TextEditingController> _platformUsernameControllers = {};
  bool _isEditing = false;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      _currentUser = authState.user;
    } else {
      
      _currentUser = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop(); 
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to view your profile.')),
        );
      });
      return;
    }

    _usernameController = TextEditingController(text: _currentUser?.username);
    _notificationTimeController = TextEditingController(text: _currentUser?.notificationTime);

    
    for (String platform in AppConstants.supportedPlatforms) {
      _platformUsernameControllers[platform] =
          TextEditingController(text: _currentUser?.platformUsernames?[platform] ?? '');
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _notificationTimeController.dispose();
    _platformUsernameControllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    
    TimeOfDay initialTime = TimeOfDay.now();
    try {
      final parts = _notificationTimeController.text.split(':');
      if (parts.length == 2) {
        initialTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      }
    } catch (e) {
      print('Error parsing notification time: $e');
    }

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
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

  void _onSavePressed() {
    if (_formKey.currentState!.validate()) {
      Map<String, String> updatedPlatformUsernames = {};
      for (String platform in AppConstants.supportedPlatforms) {
        final controller = _platformUsernameControllers[platform];
        if (controller != null && controller.text.isNotEmpty) {
          updatedPlatformUsernames[platform] = controller.text;
        }
      }

      BlocProvider.of<AuthBloc>(context).add(
        UpdateUserProfileEvent(
          username: _usernameController.text,
          notificationTime: _notificationTimeController.text,
          platformUsernames: updatedPlatformUsernames,
        ),
      );
     
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return  Scaffold(
        appBar:AppBar(title: const Text('Profile')),
        body: const Center(child: Text('User data not available.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                _onSavePressed();
              } else {
                setState(() {
                  _isEditing = true;
                });
              }
            },
          ),
        ],
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
           
            setState(() {
              _isEditing = true;
            });
          } else if (state is AuthAuthenticated) {
            _currentUser = state.user; 
            
            _usernameController.text = state.user.username;
            _notificationTimeController.text = state.user.notificationTime;
            for (String platform in AppConstants.supportedPlatforms) {
              _platformUsernameControllers[platform]?.text = state.user.platformUsernames?[platform] ?? '';
            }
            
            if (_isEditing) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated successfully!')),
              );
              setState(() {
                _isEditing = false;
              });
            }
          }
        },
        builder: (context, state) {
          if (state is AuthLoading && _currentUser == null) {
            return const LoadingIndicator();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Personal Information',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16.0),
                  AppTextField(
                    controller: _usernameController,
                    labelText: 'Username',
                    validator: InputValidator.validateUsername,
                    enabled: _isEditing,
                  ),
                  const SizedBox(height: 16.0),
                  AppTextField(
                    controller: TextEditingController(text: _currentUser!.email), 
                    labelText: 'Email',
                    enabled: false,
                  ),
                  const SizedBox(height: 16.0),
                  GestureDetector(
                    onTap: _isEditing ? () => _selectTime(context) : null,
                    child: AbsorbPointer(
                      absorbing: !_isEditing,
                      child: AppTextField(
                        controller: _notificationTimeController,
                        labelText: 'Daily Notification Time (HH:MM)',
                        validator: InputValidator.validateNotificationTime,
                        readOnly: true, 
                        suffixIcon: const Icon(Icons.access_time),
                        enabled: _isEditing, 
                      ),
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  Text(
                    'Coding Platform Usernames',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16.0),
                  ...AppConstants.supportedPlatforms.map((platform) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: AppTextField(
                        controller: _platformUsernameControllers[platform]!,
                        labelText: '${AppConstants.platformDisplayNames[platform]} Username',
                        validator: (value) => value!.isNotEmpty ? InputValidator.validatePlatformUsername(value) : null,
                        enabled: _isEditing,
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 32.0),
                  if (_isEditing) 
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _onSavePressed,
                        child: const Text('Save Changes'),
                      ),
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