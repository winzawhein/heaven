import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/theme/app_theme.dart';

class BrokerPropertyUploadForm extends StatefulWidget {
  const BrokerPropertyUploadForm({super.key});

  @override
  State<BrokerPropertyUploadForm> createState() =>
      BrokerPropertyUploadFormState();
}

class BrokerPropertyUploadFormState extends State<BrokerPropertyUploadForm> {
  // Expose the current form values for submission.
  String get title => _titleCtrl.text.trim();
  String get description => _descriptionCtrl.text.trim();
  String get location => _locationCtrl.text.trim();
  String get phone => _phoneCtrl.text.trim();

  num get price => num.tryParse(_priceCtrl.text.trim()) ?? 0;
  num get area => num.tryParse(_areaCtrl.text.trim()) ?? 0;
  num get bedrooms => num.tryParse(_bedroomsCtrl.text.trim()) ?? 0;
  num get bathrooms => num.tryParse(_bathroomsCtrl.text.trim()) ?? 0;
  num get yearBuilt => num.tryParse(_yearBuiltCtrl.text.trim()) ?? 0;

  String? get listedDate {
    final v = _listedDateCtrl.text.trim();
    return v.isEmpty ? null : v;
  }

  String get type => _type;
  String get status => _status;
  bool get isFurnished => _isFurnished;

  List<String> get amenities => List.unmodifiable(_amenities);
  List<String> get imageUrls => List.unmodifiable(_imageUrls);
  bool get isUploadingImage => _isUploadingImage;
  final _formKey = GlobalKey<FormState>();

  final _titleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _bedroomsCtrl = TextEditingController(text: '1');
  final _bathroomsCtrl = TextEditingController(text: '1');
  final _areaCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

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
    _phoneCtrl.dispose();
    _yearBuiltCtrl.dispose();
    _listedDateCtrl.dispose();
    _amenityDraftCtrl.dispose();
    _imageDraftCtrl.dispose();
    super.dispose();
  }

  bool _isUploadingImage =
      false; // Tracks loading state while file transfers to storage
  final ImagePicker _picker = ImagePicker();

  // Function to handle image source selection and file staging
  Future<void> _pickAndUploadImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality:
            70, // Keep quality slightly lower (60-70) to prevent hitting Firestore document size limits
      );

      if (pickedFile == null) return;

      setState(() => _isUploadingImage = true);

      // 1. Read file bytes locally
      final Uint8List imageBytes = await pickedFile.readAsBytes();

      // 2. Convert bytes to a Base64 String
      final String base64String = base64Encode(imageBytes);

      // 3. Create a valid Data URI string that image widgets can render
      final String dataUri = 'data:image/jpeg;base64,$base64String';

      setState(() {
        _imageUrls.add(dataUri); // Adds the text string straight to your list
        _isUploadingImage = false;
      });
    } catch (e) {
      setState(() => _isUploadingImage = false);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to process image: $e')));
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Photo Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickAndUploadImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickAndUploadImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
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
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _descriptionCtrl,
            label: 'Description',
            icon: Icons.description_outlined,
            maxLines: 5,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
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
                    DropdownMenuItem(
                      value: 'available',
                      child: Text('Available'),
                    ),
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
                    if (parsed == null || parsed <= 0)
                      return 'Enter a valid price';
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
                    if (parsed == null || parsed <= 0)
                      return 'Enter a valid area';
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
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),

          const SizedBox(height: 12),
          _buildTextField(
            controller: _phoneCtrl,
            label: 'Contact',
            icon: Icons.phone,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 14),

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
          _SectionTitle(label: 'Property Images'),
          const SizedBox(height: 10),

          // Media Action Upload Button Layout
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _isUploadingImage
                  ? null
                  : () => _showImageSourceActionSheet(context),
              icon: _isUploadingImage
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.add_a_photo_outlined),
              label: Text(
                _isUploadingImage
                    ? 'Uploading to storage...'
                    : 'Add Image from Device',
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Horizontal Preview gallery grid showing loaded assets
          if (_imageUrls.isNotEmpty)
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _imageUrls.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      _buildPropertyImage(_imageUrls[index]),
                      // Container(
                      //   width: 90,
                      //   height: 90,
                      //   margin: const EdgeInsets.only(right: 8),
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(12),
                      //     image: DecorationImage(
                      //       image: NetworkImage(_imageUrls[index]),
                      //       fit: BoxFit.cover,
                      //     ),
                      //   ),
                      // ),
                      Positioned(
                        top: 2,
                        right: 10,
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _imageUrls.removeAt(index)),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(
                              Icons.close,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

          // _SectionTitle(label: 'Images (URL list)'),
          // const SizedBox(height: 10),
          // Row(
          //   children: [
          //     Expanded(
          //       child: _buildTextField(
          //         controller: _imageDraftCtrl,
          //         label: 'Image URL',
          //         icon: Icons.image_outlined,
          //       ),
          //     ),
          //     const SizedBox(width: 10),
          //     IconButton(
          //       onPressed: () {
          //         final val = _imageDraftCtrl.text.trim();
          //         if (val.isEmpty) return;
          //         setState(() {
          //           _imageUrls.add(val);
          //           _imageDraftCtrl.clear();
          //         });
          //       },
          //       icon: const Icon(Icons.add_circle),
          //       color: AppTheme.primaryColor,
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 10),
          // Wrap(
          //   spacing: 8,
          //   runSpacing: 8,
          //   children: _imageUrls
          //       .map(
          //         (url) => Chip(
          //           label: Text(
          //             url.length > 20 ? '${url.substring(0, 20)}…' : url,
          //             maxLines: 1,
          //             overflow: TextOverflow.ellipsis,
          //           ),
          //           backgroundColor: AppTheme.surfaceColor,
          //           deleteIcon: const Icon(Icons.close),
          //           onDeleted: () {
          //             setState(() => _imageUrls.remove(url));
          //           },
          //         ),
          //       )
          //       .toList(),
          // ),

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

  Widget _buildPropertyImage(String imageStr) {
    // 1. Check if the string is a local Base64 string
    if (imageStr.startsWith('data:image')) {
      final base64Data = imageStr.split(',').last;
      return Container(
        width: 90,
        height: 90,
        margin: const EdgeInsets.only(right: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.memory(base64Decode(base64Data), fit: BoxFit.cover),
        ),
      );
    }

    // 2. Otherwise, fallback to your standard network/cached loader
    return Container(
      width: 90,
      height: 90,
      margin: const EdgeInsets.only(right: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: imageStr,
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(color: Colors.grey[300]),
          errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
        ),
      ),
    );
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
