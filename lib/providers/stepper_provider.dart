import 'package:flutter/material.dart';

class FormData with ChangeNotifier {
  int currentStep = 0;
  Map<String, String> preliminaryInfo = {};
  Map<String, String> citizenshipInfo = {};
  List<String> uploadedFiles = [];

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
