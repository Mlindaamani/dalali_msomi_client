import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fixy/services/profile_service.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileService profileService = ProfileService();
  Uint8List? _selectedImageBytes;
  bool _isUploading = false;
  String? _errorMessage;

  Uint8List? get selectedImageBytes => _selectedImageBytes;
  bool get isUploading => _isUploading;
  String? get errorMessage => _errorMessage;

  void clearPreview() {
    _selectedImageBytes = null;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> pickImage({bool fromCamera = false}) async {
    try {
      _errorMessage = null;
      notifyListeners();

      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
        allowCompression: true,
        dialogTitle: fromCamera ? 'Take a Photo' : 'Choose a Photo',
      );

      if (result != null && result.files.single.bytes != null) {
        _selectedImageBytes = result.files.single.bytes;
        notifyListeners();
        await uploadProfileImage();
      }
    } catch (e) {
      _errorMessage = 'Failed to pick image.';
      notifyListeners();
    }
  }

  Future<void> uploadProfileImage() async {
    if (_selectedImageBytes == null) return;

    _isUploading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await profileService.uploadProfileImage(_selectedImageBytes!);
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  Future<void> removeProfilePicture() async {
    _isUploading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await profileService.removeProfileImage();
      _selectedImageBytes = null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }
}
