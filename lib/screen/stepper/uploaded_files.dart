import 'package:file_picker/file_picker.dart';
import 'package:fixy/providers/stepper_provider.dart';
import 'package:flutter/material.dart';
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
        Provider.of<FormData>(context, listen: false).addFile(file.path!);
      }
    }
  }

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      Provider.of<FormData>(context, listen: false).addFile(image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formData = Provider.of<FormData>(context);
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text('Upload Face Image or Contracts'),
          ElevatedButton(
            onPressed: () => _pickFile(context),
            child: Text('Upload Files'),
          ),
          ElevatedButton(
            onPressed: () => _pickImage(context),
            child: Text('Take Photo'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: formData.uploadedFiles.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(formData.uploadedFiles[index].split('/').last),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
