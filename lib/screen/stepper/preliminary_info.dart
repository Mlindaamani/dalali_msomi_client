import 'package:fixy/providers/stepper_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreliminaryInfoStep extends StatefulWidget {
  @override
  State<PreliminaryInfoStep> createState() => _PreliminaryInfoStepState();
}

class _PreliminaryInfoStepState extends State<PreliminaryInfoStep> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter your name' : null,
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter your email' : null,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Provider.of<FormData>(
                    context,
                    listen: false,
                  ).updatePreliminaryInfo({
                    'name': _nameController.text,
                    'email': _emailController.text,
                  });
                  Provider.of<FormData>(context, listen: false).nextStep();
                }
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
