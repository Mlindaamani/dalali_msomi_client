import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:fixy/services/property_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PropertyProvider with ChangeNotifier {
  final PropertyService _propertyService = PropertyService();

  // Text controllers for form fields
  final TextEditingController propertyTypeController = TextEditingController(
    text: 'RESIDENTIAL',
  );
  final TextEditingController insurancePolicyNumberController =
      TextEditingController();
  final TextEditingController houseNumberController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController deedNumberController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController houseRulesController = TextEditingController();

  // Other fields
  List<String> _brokerIds = [];
  List<PlatformFile> _propertyImages = [];
  PlatformFile? _introContractFile;
  PlatformFile? _renewalContractFile;
  PlatformFile? _terminationContractFile;
  bool _isSubmitting = false;
  String? _error;

  // Getters
  List<String> get brokerIds => _brokerIds;
  List<PlatformFile> get propertyImages => _propertyImages;
  PlatformFile? get introContractFile => _introContractFile;
  PlatformFile? get renewalContractFile => _renewalContractFile;
  PlatformFile? get terminationContractFile => _terminationContractFile;
  bool get isSubmitting => _isSubmitting;
  String? get error => _error;

  // Broker ID management
  void addBrokerId(String value) {
    if (value.isNotEmpty && !_brokerIds.contains(value)) {
      _brokerIds.add(value);
      notifyListeners();
    }
  }

  void removeBrokerId(int index) {
    _brokerIds.removeAt(index);
    notifyListeners();
  }

  // File management
  Future<void> pickPropertyImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: true,
    );

    if (result != null) {
      _propertyImages.addAll(result.files);
      notifyListeners();
    }
  }

  Future<void> requestPermissions() async {
    await [Permission.camera, Permission.storage].request();
  }

  Future<void> pickContractFile(String contractType) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      if (contractType == 'intro') {
        _introContractFile = file;
      } else if (contractType == 'renewal') {
        _renewalContractFile = file;
      } else if (contractType == 'termination') {
        _terminationContractFile = file;
      }
      notifyListeners();
    }
  }

  void removePropertyImage(int index) {
    _propertyImages.removeAt(index);
    notifyListeners();
  }

  // Form submission
  Future<bool> submitPropertyForm() async {
    if (priceController.text.isEmpty ||
        double.tryParse(priceController.text) == null) {
      _error = 'Please enter a valid price.';
      notifyListeners();
      return false;
    }

    if (_propertyImages.isEmpty) {
      _error = 'Please select at least one property image.';
      notifyListeners();
      return false;
    }

    _isSubmitting = true;
    _error = null;
    notifyListeners();

    try {
      final propertyData = {
        'propertyType': propertyTypeController.text.isEmpty
            ? 'RESIDENTIAL'
            : propertyTypeController.text,
        'houseNumber': houseNumberController.text.isEmpty
            ? null
            : houseNumberController.text,
        'location': locationController.text.isEmpty
            ? null
            : locationController.text,
        'insurancePolicyNumber': insurancePolicyNumberController.text.isEmpty
            ? null
            : insurancePolicyNumberController.text,
        'deedNumber': deedNumberController.text.isEmpty
            ? null
            : deedNumberController.text,
        'brokerId': _brokerIds,
        'price': double.parse(priceController.text),
        'description': descriptionController.text.isEmpty
            ? null
            : descriptionController.text,
        'houseRules': houseRulesController.text.isEmpty
            ? null
            : houseRulesController.text,
      };

      final imageBytesList = _propertyImages
          .map((file) => file.bytes!)
          .toList();
      final contractBytesList = <Uint8List>[];
      if (_introContractFile != null)
        contractBytesList.add(_introContractFile!.bytes!);
      if (_renewalContractFile != null)
        contractBytesList.add(_renewalContractFile!.bytes!);
      if (_terminationContractFile != null)
        contractBytesList.add(_terminationContractFile!.bytes!);

      await _propertyService.sellDalaliMsomiProperty(
        propertyData,
        imageBytesList,
        contractBytesList,
      );

      _resetForm();
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  void _resetForm() {
    propertyTypeController.text = 'RESIDENTIAL';
    houseNumberController.clear();
    locationController.clear();
    insurancePolicyNumberController.clear();
    deedNumberController.clear();
    priceController.clear();
    descriptionController.clear();
    houseRulesController.clear();
    _brokerIds = [];
    _propertyImages = [];
    _introContractFile = null;
    _renewalContractFile = null;
    _terminationContractFile = null;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Dispose controllers
  void dispose() {
    super.dispose();
    propertyTypeController.dispose();
    houseNumberController.dispose();
    locationController.dispose();
    insurancePolicyNumberController.dispose();
    deedNumberController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    houseRulesController.dispose();
  }
}
