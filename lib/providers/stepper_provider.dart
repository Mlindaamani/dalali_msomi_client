import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class FormStepProvider with ChangeNotifier {
  int currentStep = 0;
  Map<String, String> preliminaryInfo = {};
  Map<String, String> citizenshipInfo = {};
  List<String> uploadedFiles = [];

  Future<void> requestPermissions() async {
    await [Permission.camera, Permission.storage].request();
  }

  void nextStep() {
    if (currentStep < 2) {
      currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      currentStep--;
      notifyListeners();
    }
  }

  void updatePreliminaryInfo(Map<String, String> data) {
    preliminaryInfo = data;
    notifyListeners();
  }

  void updateCitizenshipInfo(Map<String, String> data) {
    citizenshipInfo = data;
    notifyListeners();
  }

  void addFile(String filePath) {
    uploadedFiles.add(filePath);
    notifyListeners();
  }
}
