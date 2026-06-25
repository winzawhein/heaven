import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/format_helpers.dart';
import '../../domain/entities/property.dart';
import '../providers/property_providers.dart';
import '../providers/call_provider.dart';
import '../widgets/glass_container.dart';

class DetailPage extends ConsumerStatefulWidget {
  final String propertyId;

  const DetailPage({super.key, required this.propertyId});

  @override
  ConsumerState<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends ConsumerState<DetailPage> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final propertyAsync = ref.watch(propertyDetailProvider(widget.propertyId));
    final callService = ref.read(callProvider);

    return propertyAsync.when(
      data: (property) {
        if (property == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Property not found')),
          );
        }
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _buildImageSlider(context, property),
              SliverToBoxAdapter(
                child: _buildContent(context, property, callService),
              ),
            ],
          ),
          bottomNavigationBar: _buildBottomBar(context, property, callService),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) => Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Failed to load property')),
      ),
    );
  }

  Widget _buildImageSlider(BuildContext context, Property property) {
    // We track a TransformationController to know if the user has zoomed in
    final List<TransformationController> transformationControllers = List.generate(
      property.images.length,
      (_) => TransformationController(),
    );

    return SliverAppBar(
      expandedHeight: 350,
      pinned: true,
      backgroundColor: AppTheme.backgroundColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand, // Restored this to make sure elements stretch properly
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: property.images.length,
              // Dynamically disable PageView swiping ONLY when zoomed in
              physics: _isZoomed(transformationControllers)
                  ? const NeverScrollableScrollPhysics()
                  : const BouncingScrollPhysics(),
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (_, index) {
                return GestureDetector(
                  // Double tap to quickly zoom in or reset
                  onDoubleTap: () {
                    final controller = transformationControllers[index];
                    if (controller.value.isIdentity()) {
                      controller.value = Matrix4.identity()..scale(2.0);
                    } else {
                      controller.value = Matrix4.identity();
                    }
                    setState(() {}); // Force physics check
                  },
                  child: InteractiveViewer(
                    transformationController: transformationControllers[index],
                    clipBehavior: Clip.antiAlias,
                    minScale: 1.0,
                    maxScale: 3.0,
                    onInteractionEnd: (_) {
                      // Check if the user returned the image to normal scale
                      setState(() {});
                    },
                    child: CachedNetworkImage(
                      imageUrl: property.images[index],
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(color: AppTheme.surfaceColor),
                      errorWidget: (_, __, ___) => Container(
                        color: AppTheme.surfaceColor, 
                        child: const Icon(
                          Icons.broken_image,
                          color: AppTheme.textTertiary,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            // Gradient Overlay
            IgnorePointer( // Crucial: prevents the gradient layout from stealing taps
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.3),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.6),
                    ],
                  ),
                ),
              ),
            ),
            // Animated Indicator Dots
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  property.images.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: _currentPage == index ? 12 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: _currentPage == index
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to see if the current active image is zoomed in
  bool _isZoomed(List<TransformationController> controllers) {
    if (controllers.isEmpty || _currentPage >= controllers.length) return false;
    return !controllers[_currentPage].value.isIdentity();
  }

  Widget _buildContent(
    BuildContext context,
    Property property,
    CallService callService,
  ) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title & Price
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  property.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryColor, Color(0xFF8B83FF)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  FormatHelpers.formatPriceWithUnit(
                    property.price,
                    property.type,
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Location
          Row(
            children: [
              const Icon(
                Icons.location_on,
                size: 18,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  property.location,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Stats row
          GlassContainer(
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8,vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    Icons.bed_outlined,
                    '${property.bedrooms}',
                    'Bedrooms',
                  ),
                  _buildDivider(),
                  _buildStatItem(
                    Icons.bathtub_outlined,
                    '${property.bathrooms}',
                    'Bathrooms',
                  ),
                  _buildDivider(),
                  _buildStatItem(
                    Icons.square_foot_outlined,
                    FormatHelpers.formatArea(property.area).split(' ').first,
                    'Sqft',
                  ),
                  _buildDivider(),
                  _buildStatItem(
                    Icons.calendar_today,
                    '${property.yearBuilt}',
                    'Year',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Description
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            property.description,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),

          // Amenities
          const Text(
            'Amenities',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: property.amenities.map((amenity) {
              return GlassContainer(
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14,vertical: 8),
                  child: Text(
                    amenity,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Furnished status
          if (property.isFurnished)
            GlassContainer(
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding : EdgeInsets.symmetric(horizontal: 14,vertical: 10),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 18,
                      color: AppTheme.secondaryColor,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Fully Furnished',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 24),

          // Broker info
          const Text(
            'Listed by',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          GlassContainer(
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: CachedNetworkImageProvider(
                      property.brokerPhoto,
                    ),
                    backgroundColor: AppTheme.surfaceColor,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          property.brokerName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Real Estate Agent',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      _buildIconButton(
                        Icons.phone_outlined,
                        AppTheme.secondaryColor,
                        () {
                          callService.callBroker(property.brokerPhone);
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildIconButton(
                        Icons.chat_outlined,
                        AppTheme.primaryColor,
                        () {
                          callService.sendWhatsApp(property.brokerPhone);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppTheme.textTertiary),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 40, color: AppTheme.glassBorder);
  }

  Widget _buildIconButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    Property property,
    CallService callService,
  ) {
    return GlassContainer(
      margin: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(0),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      FormatHelpers.formatPriceWithUnit(
                        property.price,
                        property.type,
                      ),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      property.type == 'rent' ? 'per month' : 'total price',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _showContactSheet(context, property, callService),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryColor, Color(0xFF8B83FF)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.4),
                        blurRadius: 12,
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.phone_in_talk, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Contact',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showContactSheet(
    BuildContext context,
    Property property,
    CallService callService,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.textTertiary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            CircleAvatar(
              radius: 36,
              backgroundImage: CachedNetworkImageProvider(property.brokerPhoto),
              backgroundColor: AppTheme.surfaceColor,
            ),
            const SizedBox(height: 12),
            Text(
              property.brokerName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              FormatHelpers.formatPhone(property.brokerPhone),
              style: const TextStyle(
                color: AppTheme.textTertiary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  callService.callBroker(property.brokerPhone);
                },
                icon: const Icon(Icons.phone_in_talk),
                label: const Text(
                  'Call Now',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  callService.sendWhatsApp(property.brokerPhone);
                },
                icon: const Icon(Icons.chat),
                label: const Text(
                  'WhatsApp',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                  side: const BorderSide(color: AppTheme.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppTheme.textTertiary),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
