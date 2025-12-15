import 'package:flutter/material.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // State
  String? _selectedCountry;
  bool _subscribeNewsletter = false;
  bool _agreeTerms = false;
  double _passwordStrength = 0;

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        actions: [
          TextButton(
            onPressed: _clearForm,
            child: const Text('Clear'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          controlsBuilder: (context, details) {
            return const SizedBox.shrink();
          },
          steps: [
            Step(
              title: const Text('Personal Info'),
              content: _buildPersonalInfoSection(),
            ),
            Step(
              title: const Text('Account'),
              content: _buildAccountSection(),
            ),
            Step(
              title: const Text('Preferences'),
              content: _buildPreferencesSection(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _isFormValid() ? _submitForm : null,
          child: const Text('Submit'),
        ),
      ),
    );
  }

  // ================= SECTIONS =================

  Widget _buildPersonalInfoSection() {
    return Column(
      children: [
        TextFormField(
          controller: _firstNameController,
          decoration: const InputDecoration(labelText: 'First Name'),
          validator: _lettersOnlyValidator,
        ),
        TextFormField(
          controller: _lastNameController,
          decoration: const InputDecoration(labelText: 'Last Name'),
          validator: _lettersOnlyValidator,
        ),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'Email'),
          validator: _emailValidator,
        ),
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(labelText: 'Phone (optional)'),
          validator: _phoneValidator,
        ),
      ],
    );
  }

  Widget _buildAccountSection() {
    return Column(
      children: [
        TextFormField(
          controller: _usernameController,
          decoration: const InputDecoration(labelText: 'Username'),
          validator: _usernameValidator,
        ),
        TextFormField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Password'),
          onChanged: _checkPasswordStrength,
          validator: _passwordValidator,
        ),
        LinearProgressIndicator(
          value: _passwordStrength,
          backgroundColor: Colors.grey.shade300,
          color: _passwordStrength > 0.7
              ? Colors.green
              : _passwordStrength > 0.4
                  ? Colors.orange
                  : Colors.red,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Confirm Password'),
          validator: _confirmPasswordValidator,
        ),
      ],
    );
  }

  Widget _buildPreferencesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _selectedCountry,
          decoration: const InputDecoration(labelText: 'Country'),
          items: ['India', 'USA', 'UK', 'Germany']
              .map(
                (c) => DropdownMenuItem(value: c, child: Text(c)),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedCountry = value;
            });
          },
          validator: (value) =>
              value == null ? 'Please select a country' : null,
        ),
        CheckboxListTile(
          value: _subscribeNewsletter,
          title: const Text('Subscribe to newsletter'),
          onChanged: (value) {
            setState(() {
              _subscribeNewsletter = value ?? false;
            });
          },
        ),
        CheckboxListTile(
          value: _agreeTerms,
          title: const Text('Agree to terms'),
          onChanged: (value) {
            setState(() {
              _agreeTerms = value ?? false;
            });
          },
        ),
        if (!_agreeTerms)
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              'You must agree to terms',
              style: TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }

  // ================= LOGIC =================

  bool _isFormValid() {
    return _formKey.currentState?.validate() == true && _agreeTerms;
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _usernameController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();

    setState(() {
      _selectedCountry = null;
      _subscribeNewsletter = false;
      _agreeTerms = false;
      _passwordStrength = 0;
    });
  }

  void _submitForm() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Account created successfully 🎉'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // ================= VALIDATORS =================

  String? _lettersOnlyValidator(String? value) {
    if (value == null || value.isEmpty) return 'Required';
    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
      return 'Letters only';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) return 'Required';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Invalid email';
    }
    return null;
  }

  String? _phoneValidator(String? value) {
    if (value == null || value.isEmpty) return null;
    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Invalid phone';
    }
    return null;
  }

  String? _usernameValidator(String? value) {
    if (value == null || value.isEmpty) return 'Required';
    if (value.length < 3 || value.length > 20) {
      return '3–20 characters';
    }
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      return 'Alphanumeric only';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.length < 8) return 'Min 8 characters';
    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Add uppercase letter';
    if (!RegExp(r'[0-9]').hasMatch(value)) return 'Add number';
    if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
      return 'Add special character';
    }
    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _checkPasswordStrength(String value) {
    double strength = 0;
    if (value.length >= 8) strength += 0.25;
    if (RegExp(r'[A-Z]').hasMatch(value)) strength += 0.25;
    if (RegExp(r'[0-9]').hasMatch(value)) strength += 0.25;
    if (RegExp(r'[!@#\$&*~]').hasMatch(value)) strength += 0.25;

    setState(() {
      _passwordStrength = strength;
    });
  }
}
