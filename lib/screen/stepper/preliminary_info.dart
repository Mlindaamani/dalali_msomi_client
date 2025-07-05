import 'package:fixy/providers/stepper_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreliminaryInfoStep extends StatefulWidget {
  @override
  _PreliminaryInfoStepState createState() => _PreliminaryInfoStepState();
}

class _PreliminaryInfoStepState extends State<PreliminaryInfoStep> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              prefixIcon: Icon(Icons.person, color: Colors.indigo[600]),
            ),
            validator: (value) =>
                value!.isEmpty ? 'Please enter your name' : null,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email, color: Colors.indigo[600]),
            ),
            validator: (value) =>
                value!.isEmpty ? 'Please enter your email' : null,
          ),
          SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Provider.of<FormStepProvider>(
                    context,
                    listen: false,
                  ).updatePreliminaryInfo({
                    'name': _nameController.text,
                    'email': _emailController.text,
                  });
                  Provider.of<FormStepProvider>(
                    context,
                    listen: false,
                  ).nextStep();
                }
              },
              child: Text('Next'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
