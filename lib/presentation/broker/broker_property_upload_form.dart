import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class BrokerPropertyUploadForm extends StatefulWidget {
  const BrokerPropertyUploadForm({super.key});

  @override
  State<BrokerPropertyUploadForm> createState() => _BrokerPropertyUploadFormState();
}

class _BrokerPropertyUploadFormState extends State<BrokerPropertyUploadForm> {
  final _formKey = GlobalKey<FormState>();

  final _titleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _bedroomsCtrl = TextEditingController(text: '1');
  final _bathroomsCtrl = TextEditingController(text: '1');
  final _areaCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _yearBuiltCtrl = TextEditingController(text: '2024');
  final _listedDateCtrl = TextEditingController();

  String _type = 'sale';
  bool _isFurnished = false;
  String _status = 'available';

  final List<String> _amenities = [];
  final _amenityDraftCtrl = TextEditingController();

  final List<String> _imageUrls = [];
  final _imageDraftCtrl = TextEditingController();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    _priceCtrl.dispose();
    _bedroomsCtrl.dispose();
    _bathroomsCtrl.dispose();
    _areaCtrl.dispose();
    _locationCtrl.dispose();
    _yearBuiltCtrl.dispose();
    _listedDateCtrl.dispose();
    _amenityDraftCtrl.dispose();
    _imageDraftCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _SectionTitle(label: 'Property details'),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _titleCtrl,
            label: 'Title',
            icon: Icons.apartment_outlined,
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _descriptionCtrl,
            label: 'Description',
            icon: Icons.description_outlined,
            maxLines: 5,
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _type,
                  decoration: _dropdownDecoration('Type'),
                  items: const [
                    DropdownMenuItem(value: 'sale', child: Text('For Sale')),
                    DropdownMenuItem(value: 'rent', child: Text('For Rent')),
                  ],
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() => _type = v);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _status,
                  decoration: _dropdownDecoration('Status'),
                  items: const [
                    DropdownMenuItem(value: 'available', child: Text('Available')),
                    DropdownMenuItem(value: 'pending', child: Text('Pending')),
                    DropdownMenuItem(value: 'sold', child: Text('Sold')),
                  ],
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() => _status = v);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildNumberField(
                  controller: _priceCtrl,
                  label: 'Price',
                  icon: Icons.attach_money_outlined,
                  validator: (v) {
                    final num? parsed = v == null || v.trim().isEmpty
                        ? null
                        : num.tryParse(v.trim());
                    if (parsed == null || parsed <= 0) return 'Enter a valid price';
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildNumberField(
                  controller: _areaCtrl,
                  label: 'Area (sqft)',
                  icon: Icons.square_foot_outlined,
                  validator: (v) {
                    final num? parsed = v == null || v.trim().isEmpty
                        ? null
                        : num.tryParse(v.trim());
                    if (parsed == null || parsed <= 0) return 'Enter a valid area';
                    return null;
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildNumberField(
                  controller: _bedroomsCtrl,
                  label: 'Bedrooms',
                  icon: Icons.king_bed_outlined,
                  validator: (v) {
                    final num? parsed = v == null || v.trim().isEmpty
                        ? null
                        : num.tryParse(v.trim());
                    if (parsed == null || parsed <= 0) return 'Enter bedrooms';
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildNumberField(
                  controller: _bathroomsCtrl,
                  label: 'Bathrooms',
                  icon: Icons.bathtub_outlined,
                  validator: (v) {
                    final num? parsed = v == null || v.trim().isEmpty
                        ? null
                        : num.tryParse(v.trim());
                    if (parsed == null || parsed <= 0) return 'Enter bathrooms';
                    return null;
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _buildTextField(
            controller: _locationCtrl,
            label: 'Location',
            icon: Icons.location_on_outlined,
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildNumberField(
                  controller: _yearBuiltCtrl,
                  label: 'Year built',
                  icon: Icons.calendar_today_outlined,
                  validator: (v) {
                    final num? parsed = v == null || v.trim().isEmpty
                        ? null
                        : num.tryParse(v.trim());
                    if (parsed == null || parsed < 1900 || parsed > 2100) {
                      return 'Enter a valid year';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  controller: _listedDateCtrl,
                  label: 'Listed date (YYYY-MM-DD) (optional)',
                  icon: Icons.date_range_outlined,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          SwitchListTile(
            value: _isFurnished,
            onChanged: (v) => setState(() => _isFurnished = v),
            title: const Text('Fully furnished'),
            activeColor: AppTheme.primaryColor,
          ),

          const SizedBox(height: 20),

          _SectionTitle(label: 'Amenities'),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _amenityDraftCtrl,
                  label: 'Add amenity',
                  icon: Icons.add_circle_outline,
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () {
                  final val = _amenityDraftCtrl.text.trim();
                  if (val.isEmpty) return;
                  setState(() {
                    _amenities.add(val);
                    _amenityDraftCtrl.clear();
                  });
                },
                icon: const Icon(Icons.add_circle),
                color: AppTheme.primaryColor,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _amenities
                .map(
                  (a) => Chip(
                    label: Text(a),
                    backgroundColor: AppTheme.surfaceColor,
                    deleteIcon: const Icon(Icons.close),
                    onDeleted: () {
                      setState(() => _amenities.remove(a));
                    },
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 20),

          _SectionTitle(label: 'Images (URL list)'),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _imageDraftCtrl,
                  label: 'Image URL',
                  icon: Icons.image_outlined,
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () {
                  final val = _imageDraftCtrl.text.trim();
                  if (val.isEmpty) return;
                  setState(() {
                    _imageUrls.add(val);
                    _imageDraftCtrl.clear();
                  });
                },
                icon: const Icon(Icons.add_circle),
                color: AppTheme.primaryColor,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _imageUrls
                .map(
                  (url) => Chip(
                    label: Text(
                      url.length > 20 ? '${url.substring(0, 20)}…' : url,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    backgroundColor: AppTheme.surfaceColor,
                    deleteIcon: const Icon(Icons.close),
                    onDeleted: () {
                      setState(() => _imageUrls.remove(url));
                    },
                  ),
                )
                .toList(),
          ),

          // Keep accessors through a global form submit; actual data extraction
          // happens in the parent via GlobalKey state pattern not needed here.
          // For scaffolding, we validate only.
        ],
      ),
    );
  }

  // Allow parent to validate and show errors.
  bool validateAndGetValidity() {
    return _formKey.currentState?.validate() ?? false;
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppTheme.textTertiary),
      filled: true,
      fillColor: AppTheme.surfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppTheme.glassBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppTheme.glassBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppTheme.primaryColor),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
    );
  }

  InputDecoration _dropdownDecoration(String label) {
    return _inputDecoration(label: label, icon: Icons.arrow_drop_down);
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      maxLines: maxLines,
      style: const TextStyle(color: AppTheme.textPrimary),
      decoration: _inputDecoration(label: label, icon: icon),
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return _buildTextField(
      controller: controller,
      label: label,
      icon: icon,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: validator,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String label;

  const _SectionTitle({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppTheme.textPrimary,
      ),
    );
  }
}

