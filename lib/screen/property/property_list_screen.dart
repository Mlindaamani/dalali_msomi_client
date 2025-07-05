import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fixy/models/property_model.dart';
import 'package:fixy/services/property_service.dart';
import 'package:fixy/widgets/app_bar.dart';
import 'package:fixy/screen/property/widgets/property_list.dart';

class PropertyListScreen extends StatefulWidget {
  const PropertyListScreen({super.key});

  @override
  State<PropertyListScreen> createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends State<PropertyListScreen> {
  String? _error;
  bool _loading = true;

  final List<String> _categories = [
    'All',
    'Residential',
    'Commercial',
    'Industrial',
    'Rentals',
  ];

  List<Property> _allProperties = [];
  List<Property> _filteredProperties = [];
  String _selectedCategory = 'All';

  final TextEditingController _searchController = TextEditingController();
  final Color themeColor = const Color(0xFF4F46E5);

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Filter Properties',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4F46E5),
                ),
              ),
              const SizedBox(height: 20),

              // 🔽 Category Dropdown
              const Text('Property Type'),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                value: _selectedCategory == 'All' ? null : _selectedCategory,
                hint: const Text('Select Type'),
                items: _categories
                    .where((c) => c != 'All')
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    _onCategorySelected(value);
                    Navigator.pop(context);
                  }
                },
              ),
              const SizedBox(height: 16),

              // 🟪 Placeholder for more filters
              // I will add location, price range...later
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text('Apply Filters'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // TODO:: I will navigate remove the widget
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchProperties();

    _searchController.addListener(() {
      setState(() {
        _filteredProperties = _applyFilters();
      });
    });
  }

  Future<void> _fetchProperties() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final data = await PropertyService.getAllProperties();
      setState(() {
        _allProperties = data;
        _filteredProperties = _applyFilters();
      });
    } catch (e) {
      setState(() => _error = 'Failed to load properties');
    } finally {
      setState(() => _loading = false);
    }
  }

  List<Property> _applyFilters() {
    final query = _searchController.text.toLowerCase();
    return _allProperties.where((property) {
      final matchesCategory =
          _selectedCategory == 'All' ||
          property.propertyType.toLowerCase() ==
              _selectedCategory.toLowerCase();
      final matchesSearch =
          query.isEmpty ||
          property.description.toLowerCase().contains(query) ||
          property.location.toLowerCase().contains(query) ||
          property.propertyType.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _filteredProperties = _applyFilters();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FixyAppBar(),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.cloud_off_rounded,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _fetchProperties,
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      label: const Text(
                        'Try Again',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                const SizedBox(height: 20),

                // 🔍 Search bar with modern filter icon
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Search properties...',
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            prefixIcon: const Icon(Icons.search, size: 20),
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => _showFilterSheet(context),
                        icon: const Icon(
                          Icons.tune_rounded,
                          color: Color(0xFF4F46E5),
                          size: 26,
                        ),
                        tooltip: 'Filter',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // 🔄 Category filters
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final selected = category == _selectedCategory;

                      return GestureDetector(
                        onTap: () => _onCategorySelected(category),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                category,
                                style: TextStyle(
                                  color: selected
                                      ? themeColor
                                      : Colors.grey[800],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),

                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                height: 3,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: selected
                                      ? themeColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // 🏡 Property list
                Expanded(
                  child: PropertyList(
                    properties: _filteredProperties,
                    // onRefresh: _fetchProperties,
                  ),
                ),
              ],
            ),
    );
  }
}
