import 'package:fixy/models/property_model.dart';
import 'package:fixy/widgets/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class PropertyDetailPage extends StatelessWidget {
  final Property property;

  const PropertyDetailPage({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    const themeColor = Color(0xFF4F46E5);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Property Details'),
        foregroundColor: Colors.black87,
        elevation: 5,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            _sectionTitleWithIcon(Icons.image, 'Property Images'),
            const SizedBox(height: 8),
            _buildImageList(property.propertyImages),
            const SizedBox(height: 24),
            Text(
              '${property.propertyType} - House No. ${property.houseNumber}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: themeColor,
              ),
            ),
            const SizedBox(height: 16),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _infoRow(Icons.location_on, 'Location', property.location),
                    _infoRow(
                      Icons.attach_money,
                      'Price',
                      'Tsh ${property.price.toStringAsFixed(0)}',
                    ),
                    _infoExpandable(
                      Icons.description,
                      'Description',
                      property.description,
                    ),
                    _infoExpandable(
                      Icons.rule,
                      'House Rules',
                      property.houseRules,
                    ),
                    _infoRow(Icons.verified, 'Status', property.status),
                    _infoRow(
                      Icons.policy,
                      'Insurance Policy #',
                      property.insurancePolicyNumber,
                    ),
                    _infoRow(Icons.book, 'Deed Number', property.deedNumber),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _sectionTitleWithIcon(Icons.people_alt, 'Brokers'),
            Wrap(
              spacing: 8,
              children: property.brokerId
                  .map(
                    (id) => Chip(
                      label: Text(
                        id,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: themeColor.withValues(alpha: 0.8),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 24),
            _sectionTitleWithIcon(Icons.picture_as_pdf_rounded, 'Contracts'),
            _buildContractLinks(property.contractFiles),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showRentNowSheet(context),
                icon: const Icon(Icons.home_work, color: Colors.white),
                label: const Text(
                  'Rent Now',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            ElevatedButton(
              onPressed: () => showButtomForComingFeature(context),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(14),
                backgroundColor: themeColor.withOpacity(0.85),
              ),
              child: const Icon(Icons.chat, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.indigo, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            '$label: $value',
            style: const TextStyle(fontSize: 15, height: 1.5),
          ),
        ),
      ],
    ),
  );

  Widget _infoExpandable(IconData icon, String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: ExpansionTile(
      leading: Icon(icon, color: Colors.indigo),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      tilePadding: const EdgeInsets.symmetric(horizontal: 0),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        Text(value, style: const TextStyle(fontSize: 15, height: 1.5)),
      ],
    ),
  );

  Widget _sectionTitleWithIcon(IconData icon, String text) => Row(
    children: [
      Icon(icon, color: Color(0xFF4F46E5), size: 24),
      const SizedBox(width: 8),
      Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Color(0xFF4F46E5),
        ),
      ),
    ],
  );

  Widget _buildImageList(List<PropertyImage> images) => SizedBox(
    height: 180,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: images.length,
      separatorBuilder: (_, __) => const SizedBox(width: 10),
      itemBuilder: (context, index) {
        final image = images[index];
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            image.url,
            width: 160,
            fit: BoxFit.cover,
            headers: const {'ngrok-skip-browser-warning': 'true'},
            loadingBuilder: (context, child, progress) => progress == null
                ? child
                : Container(
                    width: 160,
                    color: Colors.indigo.shade100,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
            errorBuilder: (_, __, ___) => Container(
              width: 160,
              color: Colors.grey.shade300,
              child: const Center(child: Icon(Icons.broken_image)),
            ),
          ),
        );
      },
    ),
  );

  Widget _buildContractLinks(List<ContractFile> contracts) => Column(
    children: contracts
        .map(
          (contract) => Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _linkButton('View Intro Contract', contract.introContractUrl),
                  _linkButton(
                    'View Renewal Contract',
                    contract.renewalContractUrl,
                  ),
                  _linkButton(
                    'View Termination Contract',
                    contract.terminationContractUrl,
                  ),
                ],
              ),
            ),
          ),
        )
        .toList(),
  );

  Widget _linkButton(String label, String url) => SizedBox(
    width: double.infinity,
    child: TextButton.icon(
      onPressed: () => _launchURL(url),
      icon: const Icon(Icons.picture_as_pdf_rounded, size: 22),
      label: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF4F46E5),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(vertical: 12),
        textStyle: const TextStyle(fontSize: 16),
      ),
    ),
  );

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showRentNowSheet(BuildContext context) {
    const themeColor = Color(0xFF4F46E5);
    final durationController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    final endDateNotifier = ValueNotifier('');
    final rentalAmountNotifier = ValueNotifier('');

    durationController.addListener(() {
      final duration = int.tryParse(durationController.text) ?? 0;
      final end = DateTime(
        selectedDate.year,
        selectedDate.month + duration,
        selectedDate.day,
      );
      endDateNotifier.value = DateFormat('yyyy-MM-dd').format(end);
      rentalAmountNotifier.value =
          'Tsh ${(property.price * duration).toStringAsFixed(0)}';
    });

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          20,
          16,
          MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Confirm Rental',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: themeColor,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Property: ${property.propertyType} - ${property.houseNumber}',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Location: ${property.location}',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Price: Tsh ${property.price.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Rental Duration (months)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: themeColor, size: 20),
                  const SizedBox(width: 8),
                  const Text('Start Date:', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() => selectedDate = picked);
                      }
                    },
                    child: Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.event, color: themeColor, size: 20),
                  const SizedBox(width: 8),
                  const Text('End Date:', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  ValueListenableBuilder(
                    valueListenable: endDateNotifier,
                    builder: (_, String endDate, __) =>
                        Text(endDate, style: const TextStyle(fontSize: 16)),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              Row(
                children: [
                  const Icon(
                    Icons.attach_money_rounded,
                    color: themeColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text('Total Amount:', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  ValueListenableBuilder(
                    valueListenable: rentalAmountNotifier,
                    builder: (_, String amount, __) => Text(
                      amount,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final duration = durationController.text.trim();
                    if (duration.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Enter duration')),
                      );
                      return;
                    }
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Processing rental request!'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.send, color: Colors.white),
                  label: const Text(
                    'Confirm Rent',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
