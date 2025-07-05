import 'package:fixy/providers/stepper_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CitizenshipInfoStep extends StatefulWidget {
  @override
  State<CitizenshipInfoStep> createState() => _CitizenshipInfoStepState();
}

class _CitizenshipInfoStepState extends State<CitizenshipInfoStep> {
  final _formKey = GlobalKey<FormState>();
  final _countryController = TextEditingController();
  final _passportController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _countryController,
              decoration: InputDecoration(labelText: 'Country of Citizenship'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter your country' : null,
            ),
            TextFormField(
              controller: _passportController,
              decoration: InputDecoration(labelText: 'Passport Number'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter your passport number' : null,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Provider.of<FormStepProvider>(
                    context,
                    listen: false,
                  ).updateCitizenshipInfo({
                    'country': _countryController.text,
                    'passport': _passportController.text,
                  });
                  Provider.of<FormStepProvider>(
                    context,
                    listen: false,
                  ).nextStep();
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
