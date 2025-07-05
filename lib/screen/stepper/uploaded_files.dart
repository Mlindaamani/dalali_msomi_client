import 'package:file_picker/file_picker.dart';
import 'package:fixy/providers/stepper_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class FileUploadStep extends StatelessWidget {
  Future<void> _pickFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'png'],
    );
    if (result != null) {
      for (var file in result.files) {
        Provider.of<FormStepProvider>(
          context,
          listen: false,
        ).addFile(file.path!);
      }
    }
  }

  Future<void> _pickImage(BuildContext context) async {
    final stepperProvider = Provider.of<FormStepProvider>(context);
    stepperProvider.requestPermissions();
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      Provider.of<FormStepProvider>(context, listen: false).addFile(image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formData = Provider.of<FormStepProvider>(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload your face image or contracts',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: theme.primaryColor,
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _pickFile(context),
                icon: Icon(Icons.upload_file),
                label: Text('Upload Files'),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _pickImage(context),
                icon: Icon(Icons.camera_alt),
                label: Text('Take Photo'),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: formData.uploadedFiles.length,
            itemBuilder: (context, index) => Card(
              elevation: 2,
              child: ListTile(
                leading: Icon(
                  formData.uploadedFiles[index].endsWith('.pdf')
                      ? Icons.picture_as_pdf
                      : Icons.image,
                  color: Colors.indigoAccent,
                ),
                title: Text(
                  formData.uploadedFiles[index].split('/').last,
                  style: GoogleFonts.poppins(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
