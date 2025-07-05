import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:fixy/models/property_model.dart';
import 'package:fixy/screen/property/property_detail_screen.dart';

class PropertyList extends StatelessWidget {
  final List<Property> properties;
  final Future<void> Function()? onRefresh;

  const PropertyList({super.key, required this.properties, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    const themeColor = Color(0xFF4F46E5);

    if (properties.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.search_off, size: 80, color: Colors.indigoAccent),
            SizedBox(height: 16),
            Text(
              'No properties found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return LiquidPullToRefresh(
      onRefresh: onRefresh ?? _defaultRefresh,
      color: Colors.indigoAccent,
      backgroundColor: const Color(0xFFF3F4F6),
      height: 200,
      animSpeedFactor: 6,
      showChildOpacityTransition: false,

      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: properties.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final property = properties[index];
          final imageUrl = property.propertyImages.isNotEmpty
              ? property.propertyImages.first.url
              : '';

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PropertyDetailPage(property: property),
                ),
              );
            },
            child: Card(
              margin: EdgeInsets.zero,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (imageUrl.isNotEmpty)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Image.network(
                        headers: const {'ngrok-skip-browser-warning': 'true'},
                        imageUrl,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _imageFallback(),
                      ),
                    )
                  else
                    _imageFallback(),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${property.propertyType} - No. ${property.houseNumber}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              property.location,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const Spacer(),
                            _buildStatusChip(property.status),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tsh ${property.price.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: themeColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          property.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _imageFallback() => Container(
    width: double.infinity,
    height: 160,
    color: Colors.grey.shade300,
    child: const Icon(Icons.broken_image, size: 50, color: Colors.indigoAccent),
  );

  Widget _buildStatusChip(String status) {
    final isAvailable = status.toLowerCase() == 'available';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isAvailable ? Colors.green[100] : Colors.red[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: isAvailable ? Colors.green[800] : Colors.red[800],
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> _defaultRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
