import 'package:fixy/providers/stepper_provider.dart';
import 'package:fixy/screen/stepper/citizenship_info.dart';
import 'package:fixy/screen/stepper/preliminary_info.dart';
import 'package:fixy/screen/stepper/uploaded_files.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class DalaliMsomiStepperForm extends StatelessWidget {
  final List<String> stepTitles = [
    'Preliminary Info',
    'Citizenship Info',
    'File Upload',
  ];

  @override
  Widget build(BuildContext context) {
    final formData = Provider.of<FormStepProvider>(context);
    final theme = Theme.of(context);

    List<Widget> steps = [
      PreliminaryInfoStep(),
      CitizenshipInfoStep(),
      FileUploadStep(),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Complete Your Profile',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: theme.primaryColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Progress Indicator
          Padding(
            padding: EdgeInsets.all(16.0),
            child: LinearProgressIndicator(
              value: (formData.currentStep + 1) / steps.length,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.indigoAccent),
              minHeight: 8,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          // Step Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              stepTitles[formData.currentStep],
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: theme.primaryColor,
              ),
            ),
          ),
          // Step Content
          Expanded(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: Card(
                key: ValueKey<int>(formData.currentStep),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: steps[formData.currentStep],
                ),
              ),
            ),
          ),
          // Navigation Buttons
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (formData.currentStep > 0)
                  OutlinedButton(
                    onPressed: () => formData.previousStep(),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: theme.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      'Previous',
                      style: GoogleFonts.poppins(color: theme.primaryColor),
                    ),
                  ),
                ElevatedButton(
                  onPressed: formData.currentStep < 2
                      ? () => formData.nextStep()
                      : () => _submitForm(context, formData),
                  child: Text(formData.currentStep < 2 ? 'Next' : 'Submit'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm(BuildContext context, FormStepProvider formStepProvider) {
    print('Preliminary Info: ${formStepProvider.preliminaryInfo}');
    print('Citizenship Info: ${formStepProvider.citizenshipInfo}');
    print('Uploaded Files: ${formStepProvider.uploadedFiles}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Form Submitted!'),
        backgroundColor: Colors.indigo[600],
      ),
    );
  }
}
