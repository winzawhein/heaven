import 'dart:convert'; // Added for base64Decode
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/format_helpers.dart';
import '../../domain/entities/property.dart';
import '../../l10n/app_localizations.dart';

class PropertyCardImageSection extends StatelessWidget {

  final Property property;

  const PropertyCardImageSection({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (property.images.isNotEmpty)
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: _buildAdaptiveImage(property.images.first),
          ),
        _buildPriceBadge(context),
        _buildStatusBadge(context),
      ],
    );

  }

  // Adaptive method capable of evaluating Base64 and remote URL configurations dynamically
  Widget _buildAdaptiveImage(String imageStr) {
    if (imageStr.startsWith('data:image')) {
      try {
        final base64Data = imageStr.split(',').last;
        return Image.memory(
          base64Decode(base64Data),
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
        );
      } catch (e) {
        return Container(
          height: 200,
          color: AppTheme.surfaceColor,
          child: const Icon(
            Icons.broken_image,
            color: AppTheme.textTertiary,
          ),
        );
      }
    }

    // Standard remote resource handler fallback logic
    return CachedNetworkImage(
      imageUrl: imageStr,
      height: 200,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(
        height: 200,
        color: AppTheme.surfaceColor,
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      errorWidget: (_, __, ___) => Container(
        height: 200,
        color: AppTheme.surfaceColor,
        child: const Icon(
          Icons.broken_image,
          color: AppTheme.textTertiary,
        ),
      ),
    );
  }

  Widget _buildPriceBadge(BuildContext context) {
    return Positioned(
      top: 12,
      right: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.primaryColor, Color(0xFF8B83FF)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          FormatHelpers.formatPriceWithUnit(property.price, property.type),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (property.status == 'available') return const SizedBox.shrink();

    final statusText = switch (property.status) {
      'sale' => l10n.statusSale,
      'rent' => l10n.statusRent,
      _ => property.status.toUpperCase(),
    };

    return Positioned(
      top: 12,
      left: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppTheme.accentColor.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          statusText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

}