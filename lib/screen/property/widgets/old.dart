// import 'dart:typed_data';
// import 'package:fixy/services/api_client.dart';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';

// class SellDalaliMsomiProperty extends StatefulWidget {
//   const SellDalaliMsomiProperty({super.key});
//   @override
//   State<SellDalaliMsomiProperty> createState() =>
//       _SellDalaliMsomiPropertyState();
// }

// class _SellDalaliMsomiPropertyState extends State<SellDalaliMsomiProperty> {
//   final _formKey = GlobalKey<FormState>();
//   bool _isSubmitting = false;

//   // Form fields
//   final TextEditingController _brokerIdController = TextEditingController();
//   List<String> brokerIds = [];
//   String? propertyType = 'RESIDENTIAL';
//   String? houseNumber;
//   String? location;
//   String? insurancePolicyNumber;
//   String? deedNumber;
//   double? price;
//   String? description;
//   String? houseRules;

//   // Files
//   List<PlatformFile> propertyImages = [];
//   PlatformFile? introContractFile;
//   PlatformFile? renewalContractFile;
//   PlatformFile? terminationContractFile;

//   @override
//   void dispose() {
//     _brokerIdController.dispose();
//     super.dispose();
//   }

//   Future<void> pickPropertyImages() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.image,
//       allowMultiple: true,
//       withData: true,
//     );

//     if (result != null) {
//       setState(() {
//         propertyImages.addAll(result.files);
//       });
//     }
//   }

//   Future<void> pickContractFile(String contractType) async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//       withData: true,
//     );
//     if (result != null && result.files.isNotEmpty) {
//       setState(() {
//         final file = result.files.first;
//         if (contractType == 'intro') {
//           introContractFile = file;
//         } else if (contractType == 'renewal') {
//           renewalContractFile = file;
//         } else if (contractType == 'termination') {
//           terminationContractFile = file;
//         }
//       });
//     }
//   }

//   void removePropertyImage(int index) {
//     setState(() {
//       propertyImages.removeAt(index);
//     });
//   }

//   void addBrokerId() {
//     final value = _brokerIdController.text.trim();
//     if (value.isNotEmpty && !brokerIds.contains(value)) {
//       setState(() {
//         brokerIds.add(value);
//         _brokerIdController.clear();
//       });
//     }
//   }

//   void removeBrokerId(int index) {
//     setState(() {
//       brokerIds.removeAt(index);
//     });
//   }

//   Future<void> submitForm() async {
//     if (!_formKey.currentState!.validate()) return;

//     if (price == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter a valid price.')),
//       );
//       return;
//     }

//     if (propertyImages.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please select at least one property image.'),
//         ),
//       );
//       return;
//     }

//     setState(() {
//       _isSubmitting = true;
//     });

//     try {
//       final propertyData = {
//         'propertyType': propertyType ?? 'RESIDENTIAL',
//         'houseNumber': houseNumber,
//         'location': location,
//         'insurancePolicyNumber': insurancePolicyNumber,
//         'deedNumber': deedNumber,
//         'brokerId': brokerIds,
//         'price': price,
//         'description': description,
//         'houseRules': houseRules,
//       };
//       final imageBytesList = propertyImages.map((file) => file.bytes!).toList();

//       List<Uint8List> contractBytesList = [];
//       if (introContractFile != null) {
//         contractBytesList.add(introContractFile!.bytes!);
//       }
//       if (renewalContractFile != null) {
//         contractBytesList.add(renewalContractFile!.bytes!);
//       }
//       if (terminationContractFile != null) {
//         contractBytesList.add(terminationContractFile!.bytes!);
//       }

//       final response = await HttpClientService.uploadPropertyWithAttachments(
//         'api/properties',
//         propertyData,
//         imageBytesList,
//         contractBytesList,
//       );

//       if (response.statusCode >= 200 && response.statusCode < 300) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Property created successfully!')),
//           );
//           _formKey.currentState!.reset();
//           setState(() {
//             propertyImages.clear();
//             brokerIds.clear();
//             introContractFile = null;
//             renewalContractFile = null;
//             terminationContractFile = null;
//             price = null;
//             propertyType = 'RESIDENTIAL';
//           });
//         }
//       } else {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                 'Failed to create property. Server responded with status code: ${response.statusCode}',
//               ),
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error occurred while submitting form: $e')),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isSubmitting = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     const brandColor = Color(0xFF4F46E5);
//     const spacing = 20.0;

//     InputDecoration inputDecoration(String label) => InputDecoration(
//       labelText: label,
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: brandColor, width: 2),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: brandColor.withOpacity(0.3)),
//       ),
//     );

//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text(
//           'Create Property',
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         elevation: 4,
//         backgroundColor: brandColor,
//       ),
//       backgroundColor: brandColor.withOpacity(0.05),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _isSubmitting ? null : submitForm,
//         backgroundColor: brandColor,
//         icon: const Icon(Icons.check, color: Colors.white),
//         label: const Text('Submit', style: TextStyle(color: Colors.white)),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _sectionCard(
//                 title: 'Property Info',
//                 children: [
//                   DropdownButtonFormField<String>(
//                     value: propertyType,
//                     decoration: inputDecoration('Property Type'),
//                     items: const [
//                       DropdownMenuItem(
//                         value: 'RESIDENTIAL',
//                         child: Text('Residential'),
//                       ),
//                       DropdownMenuItem(
//                         value: 'COMMERCIAL',
//                         child: Text('Commercial'),
//                       ),
//                     ],
//                     onChanged: (val) => setState(() => propertyType = val),
//                     validator: (val) =>
//                         val == null ? 'Property type is required' : null,
//                   ),
//                   const SizedBox(height: spacing),
//                   TextFormField(
//                     decoration: inputDecoration('House Number'),
//                     onChanged: (val) => houseNumber = val.trim(),
//                   ),
//                   const SizedBox(height: spacing),
//                   TextFormField(
//                     decoration: inputDecoration('Location'),
//                     onChanged: (val) => location = val.trim(),
//                   ),
//                   const SizedBox(height: spacing),
//                   TextFormField(
//                     decoration: inputDecoration('Insurance Policy Number'),
//                     onChanged: (val) => insurancePolicyNumber = val.trim(),
//                   ),
//                   const SizedBox(height: spacing),
//                   TextFormField(
//                     decoration: inputDecoration('Deed Number'),
//                     onChanged: (val) => deedNumber = val.trim(),
//                   ),
//                 ],
//               ),

//               _sectionCard(
//                 title: 'Brokers',
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: TextFormField(
//                           controller: _brokerIdController,
//                           decoration: inputDecoration('Add Broker ID'),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       ElevatedButton(
//                         onPressed: addBrokerId,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: brandColor,
//                           minimumSize: const Size(80, 48),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: const Text(
//                           'Add',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   Wrap(
//                     spacing: 8,
//                     children: List.generate(brokerIds.length, (index) {
//                       return Chip(
//                         label: Text(brokerIds[index]),
//                         backgroundColor: brandColor.withOpacity(0.15),
//                         labelStyle: const TextStyle(color: brandColor),
//                         deleteIconColor: brandColor,
//                         onDeleted: () => removeBrokerId(index),
//                       );
//                     }),
//                   ),
//                 ],
//               ),

//               _sectionCard(
//                 title: 'Pricing & Description',
//                 children: [
//                   TextFormField(
//                     decoration: inputDecoration('Price'),
//                     keyboardType: const TextInputType.numberWithOptions(
//                       decimal: true,
//                     ),
//                     onChanged: (val) => price = double.tryParse(val),
//                     validator: (val) {
//                       if (val == null || val.isEmpty)
//                         return 'Price is required';
//                       if (double.tryParse(val) == null)
//                         return 'Enter a valid number';
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: spacing),
//                   TextFormField(
//                     decoration: inputDecoration('Description'),
//                     maxLines: 3,
//                     onChanged: (val) => description = val.trim(),
//                   ),
//                   const SizedBox(height: spacing),
//                   TextFormField(
//                     decoration: inputDecoration('House Rules'),
//                     maxLines: 2,
//                     onChanged: (val) => houseRules = val.trim(),
//                   ),
//                 ],
//               ),

//               _sectionCard(
//                 title: 'Images & Contracts',
//                 children: [
//                   ElevatedButton.icon(
//                     onPressed: pickPropertyImages,
//                     icon: const Icon(Icons.image_rounded, color: Colors.white),
//                     label: const Text(
//                       'Select Property Images',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: brandColor,
//                       minimumSize: const Size.fromHeight(48),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   if (propertyImages.isEmpty)
//                     Text(
//                       'No images selected.',
//                       style: TextStyle(color: Colors.grey[600], fontSize: 16),
//                     )
//                   else
//                     SizedBox(
//                       height: 120,
//                       child: GridView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemCount: propertyImages.length,
//                         gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 3,
//                               crossAxisSpacing: 8,
//                               mainAxisSpacing: 8,
//                             ),
//                         itemBuilder: (_, index) {
//                           final file = propertyImages[index];
//                           return Stack(
//                             fit: StackFit.expand,
//                             children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(10),
//                                 child: Image.memory(
//                                   file.bytes!,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               Positioned(
//                                 top: 4,
//                                 right: 4,
//                                 child: GestureDetector(
//                                   onTap: () => removePropertyImage(index),
//                                   child: Container(
//                                     decoration: const BoxDecoration(
//                                       color: Colors.black54,
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: const Icon(
//                                       Icons.close,
//                                       color: Colors.white,
//                                       size: 20,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           );
//                         },
//                       ),
//                     ),
//                   const SizedBox(height: spacing),
//                   ..._buildContractButtons(brandColor),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _sectionCard({required String title, required List<Widget> children}) {
//     const brandColor = Color(0xFF4F46E5);
//     return Container(
//       margin: const EdgeInsets.only(bottom: 24),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 18,
//               color: brandColor,
//             ),
//           ),
//           const SizedBox(height: 16),
//           ...children,
//         ],
//       ),
//     );
//   }

//   List<Widget> _buildContractButtons(Color brandColor) => [
//     _contractButton('intro', introContractFile, 'Intro Contract', brandColor),
//     const SizedBox(height: 8),
//     _contractButton(
//       'renewal',
//       renewalContractFile,
//       'Renewal Contract',
//       brandColor,
//     ),
//     const SizedBox(height: 8),
//     _contractButton(
//       'termination',
//       terminationContractFile,
//       'Termination Contract',
//       brandColor,
//     ),
//   ];

//   Widget _contractButton(String type, dynamic file, String label, Color color) {
//     return ElevatedButton.icon(
//       onPressed: () => pickContractFile(type),
//       icon: const Icon(Icons.picture_as_pdf_rounded, color: Colors.white),
//       label: Text(
//         file == null ? 'Select $label PDF' : 'Change $label (${file.name})',
//         style: const TextStyle(fontSize: 16, color: Colors.white),
//       ),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: color,
//         minimumSize: const Size.fromHeight(48),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }
// }
