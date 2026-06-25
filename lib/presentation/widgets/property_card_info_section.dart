import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/format_helpers.dart';
import '../../domain/entities/property.dart';

class PropertyCardInfoSection extends StatelessWidget {
  final Property property;

  const PropertyCardInfoSection({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            property.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 14,
                color: AppTheme.textTertiary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  property.location,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _InfoChip(
                icon: Icons.bed_outlined,
                label: '${property.bedrooms} Beds',
              ),
              const SizedBox(width: 16),
              _InfoChip(
                icon: Icons.bathtub_outlined,
                label: '${property.bathrooms} Baths',
              ),
              const SizedBox(width: 16),
              _InfoChip(
                icon: Icons.square_foot_outlined,
                label: FormatHelpers.formatArea(property.area).split(' ').first,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppTheme.secondaryColor),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
