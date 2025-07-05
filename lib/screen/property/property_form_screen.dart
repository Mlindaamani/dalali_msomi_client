import 'package:fixy/providers/property_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

class SellDalaliMsomiProperty extends StatefulWidget {
  const SellDalaliMsomiProperty({super.key});

  @override
  State<SellDalaliMsomiProperty> createState() =>
      _SellDalaliMsomiPropertyState();
}

class _SellDalaliMsomiPropertyState extends State<SellDalaliMsomiProperty> {
  final _formKey = GlobalKey<FormState>();
  final _brokerIdController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    final propertyProvider = Provider.of<PropertyProvider>(context);
    propertyProvider.dispose();
    _brokerIdController.dispose();
  }

  void _handleSellingProperty(BuildContext context) async {
    final propertyProvider = Provider.of<PropertyProvider>(
      context,
      listen: false,
    );

    if (_formKey.currentState!.validate()) {
      final success = await propertyProvider.submitPropertyForm();

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'You have successfully created sold a property',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        Navigator.pushNamed(context, '/');
      }

      if (propertyProvider.error != null) {
        showDialog(
          context: context,
          builder: (context) => Text(
            propertyProvider.error!,
            style: TextStyle(color: Colors.red),
          ),
        );
        return;
      }

      if (propertyProvider.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              propertyProvider.error!,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.white,
          ),
        );
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final propertyProvider = Provider.of<PropertyProvider>(context);
    const brandColor = Color(0xFF4F46E5);
    const spacing = 20.0;

    InputDecoration inputDecoration(String label) => InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: brandColor, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: brandColor.withOpacity(0.3)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Create Property',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        elevation: 4,
        backgroundColor: brandColor,
      ),
      backgroundColor: brandColor.withOpacity(0.05),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: propertyProvider.isSubmitting
            ? null
            : () => _handleSellingProperty(context),
        backgroundColor: brandColor,
        icon: const Icon(Icons.check, color: Colors.white),
        label: Text(
          propertyProvider.isSubmitting ? 'Wait...' : 'Submit',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionCard(
                title: 'Property Info',
                children: [
                  DropdownButtonFormField<String>(
                    value: propertyProvider.propertyTypeController.text.isEmpty
                        ? 'RESIDENTIAL'
                        : propertyProvider.propertyTypeController.text,
                    decoration: inputDecoration('Property Type'),
                    items: const [
                      DropdownMenuItem(
                        value: 'RESIDENTIAL',
                        child: Text('Residential'),
                      ),
                      DropdownMenuItem(
                        value: 'COMMERCIAL',
                        child: Text('Commercial'),
                      ),
                    ],
                    onChanged: (value) {
                      propertyProvider.propertyTypeController.text =
                          value ?? 'RESIDENTIAL';
                    },
                    validator: (value) =>
                        value == null ? 'Property type is required' : null,
                  ),
                  const SizedBox(height: spacing),
                  TextFormField(
                    controller: propertyProvider.houseNumberController,
                    decoration: inputDecoration('House Number'),
                  ),
                  const SizedBox(height: spacing),
                  TextFormField(
                    controller: propertyProvider.locationController,
                    decoration: inputDecoration('Location'),
                    validator: (value) =>
                        value == null ? 'Location is required' : null,
                  ),
                  const SizedBox(height: spacing),
                  TextFormField(
                    controller:
                        propertyProvider.insurancePolicyNumberController,
                    decoration: inputDecoration('Insurance Policy Number'),
                  ),
                  const SizedBox(height: spacing),
                  TextFormField(
                    controller: propertyProvider.deedNumberController,
                    decoration: inputDecoration('Deed Number'),
                  ),
                ],
              ),
              _sectionCard(
                title: 'Brokers',
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _brokerIdController,
                          decoration: inputDecoration('Add Broker ID'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          propertyProvider.addBrokerId(
                            _brokerIdController.text.trim(),
                          );
                          _brokerIdController.clear();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandColor,
                          minimumSize: const Size(80, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Add',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: List.generate(propertyProvider.brokerIds.length, (
                      index,
                    ) {
                      return Chip(
                        label: Text(propertyProvider.brokerIds[index]),
                        backgroundColor: brandColor.withOpacity(0.15),
                        labelStyle: const TextStyle(color: brandColor),
                        deleteIconColor: brandColor,
                        onDeleted: () => propertyProvider.removeBrokerId(index),
                      );
                    }),
                  ),
                ],
              ),
              _sectionCard(
                title: 'Pricing & Description',
                children: [
                  TextFormField(
                    controller: propertyProvider.priceController,
                    decoration: inputDecoration('Price'),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Price is required';
                      if (double.tryParse(value) == null)
                        return 'Enter a valid number';
                      return null;
                    },
                  ),
                  const SizedBox(height: spacing),
                  TextFormField(
                    controller: propertyProvider.descriptionController,
                    decoration: inputDecoration('Description'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: spacing),
                  TextFormField(
                    controller: propertyProvider.houseRulesController,
                    decoration: inputDecoration('House Rules'),
                    maxLines: 2,
                  ),
                ],
              ),
              _sectionCard(
                title: 'Images & Contracts',
                children: [
                  ElevatedButton.icon(
                    onPressed: propertyProvider.pickPropertyImages,
                    icon: const Icon(Icons.image_rounded, color: Colors.white),
                    label: const Text(
                      'Select Property Images',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandColor,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (propertyProvider.propertyImages.isEmpty)
                    Text(
                      'No images selected.',
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    )
                  else
                    SizedBox(
                      height: 120,
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: propertyProvider.propertyImages.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                        itemBuilder: (_, index) {
                          final file = propertyProvider.propertyImages[index];
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.memory(
                                  file.bytes!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () => propertyProvider
                                      .removePropertyImage(index),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: spacing),
                  ..._buildContractButtons(brandColor, propertyProvider),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionCard({required String title, required List<Widget> children}) {
    const brandColor = Color(0xFF4F46E5);
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: brandColor,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  List<Widget> _buildContractButtons(
    Color brandColor,
    PropertyProvider provider,
  ) => [
    _contractButton(
      'intro',
      provider.introContractFile,
      'Intro Contract',
      brandColor,
      provider,
    ),
    const SizedBox(height: 8),
    _contractButton(
      'renewal',
      provider.renewalContractFile,
      'Renewal Contract',
      brandColor,
      provider,
    ),
    const SizedBox(height: 8),
    _contractButton(
      'termination',
      provider.terminationContractFile,
      'Termination Contract',
      brandColor,
      provider,
    ),
  ];

  Widget _contractButton(
    String type,
    PlatformFile? file,
    String label,
    Color color,
    PropertyProvider provider,
  ) {
    return ElevatedButton.icon(
      onPressed: () => provider.pickContractFile(type),
      icon: const Icon(Icons.picture_as_pdf_rounded, color: Colors.white),
      label: Text(
        file == null ? 'Select $label PDF' : 'Change $label (${file.name})',
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
