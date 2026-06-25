import 'package:flutter/material.dart';

import '../../core/firebase/broker_listings_repository.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/broker_listing_input.dart';

import 'broker_property_upload_form.dart';

class BrokerPropertyUploadPage extends StatefulWidget {

  const BrokerPropertyUploadPage({super.key});

  @override
  State<BrokerPropertyUploadPage> createState() => _BrokerPropertyUploadPageState();
}

class _BrokerPropertyUploadPageState extends State<BrokerPropertyUploadPage> {
  bool isSubmitting = false;

  final _listingsRepo = const BrokerListingsRepository();

  final _brokerFormKey = GlobalKey<BrokerPropertyUploadFormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Property'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Property submission',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'No backend is connected yet. Submitting shows a mock success message.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textTertiary,
                ),
              ),
              const SizedBox(height: 16),

              BrokerPropertyUploadForm(key: _brokerFormKey),

              const SizedBox(height: 22),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          setState(() => isSubmitting = true);
                          await Future<void>.delayed(
                            const Duration(milliseconds: 700),
                          );
                          if (!mounted) return;
                          setState(() => isSubmitting = false);

                          final formState =
                              _brokerFormKey.currentState as BrokerPropertyUploadFormState?;
                          if (formState == null) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Form not ready'),
                              ),
                            );
                            return;
                          }

                          final formValid = formState.validateAndGetValidity();
                          if (!formValid) {
                            if (!mounted) return;
                            setState(() => isSubmitting = false);
                            return;
                          }

                          final input = BrokerListingInput(
                            title: formState.title,
                            description: formState.description,
                            price: formState.price,
                            area: formState.area,
                            bedrooms: formState.bedrooms,
                            bathrooms: formState.bathrooms,
                            location: formState.location,
                            yearBuilt: formState.yearBuilt,
                            listedDate: formState.listedDate,
                            type: formState.type,
                            status: formState.status,
                            isFurnished: formState.isFurnished,
                            amenities: formState.amenities,
                            imageUrls: formState.imageUrls,
                          );

                          await _listingsRepo.createListing(input: input);

                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Property saved'),
                            ),
                          );
                        },
                  icon: isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.cloud_upload_outlined),
                  label: Text(
                    isSubmitting ? 'Submitting…' : 'Submit listing',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
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


