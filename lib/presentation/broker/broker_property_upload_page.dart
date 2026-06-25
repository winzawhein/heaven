import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import 'broker_property_upload_form.dart';

class BrokerPropertyUploadPage extends StatefulWidget {

  const BrokerPropertyUploadPage({super.key});

  @override
  State<BrokerPropertyUploadPage> createState() => _BrokerPropertyUploadPageState();
}

class _BrokerPropertyUploadPageState extends State<BrokerPropertyUploadPage> {
  bool isSubmitting = false;

  // Scaffolding: we only validate visually (no cross-widget validate wiring yet).
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

              const BrokerPropertyUploadForm(),

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

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Property saved (mock).'),
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


