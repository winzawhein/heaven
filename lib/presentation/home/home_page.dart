import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/format_helpers.dart';
import '../../domain/entities/property.dart';
import '../../l10n/app_localizations.dart';

import '../providers/locale_provider.dart';
import '../providers/property_providers.dart';
import '../widgets/glass_container.dart';
import '../widgets/property_card.dart';
import '../listing/listing_page.dart';
import '../detail/detail_page.dart';
import '../broker/broker_auth_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final FocusNode _searchFocusNode = FocusNode();
  TextEditingController _searchCtrl = TextEditingController();
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      if (!mounted) return;
      setState(() => _hasFocus = _searchFocusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _navigateToBrokerPortal(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const BrokerAuthPage()));
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;

    final featuredAsync = ref.watch(featuredPropertiesProvider);
    final searchResults = ref.watch(searchResultsProvider);
    final searchQuery = ref.watch(searchProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              expandedHeight: 120,
              collapsedHeight: 80,
              flexibleSpace: FlexibleSpaceBar(
                background: _buildHeader(context),
              ),
              actions: [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.language, color: AppTheme.textPrimary),
                  tooltip: 'Change Language',
                  onSelected: (String languageCode) {
                    ref
                        .read(localeProvider.notifier)
                        .changeLocale(languageCode);
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem(value: 'en', child: Text('English')),
                    const PopupMenuItem(
                      value:
                          'my', // Or your other supported localizations language codes
                      child: Text('Myanmar'),
                    ),
                  ],
                ),
                IconButton(
                  tooltip: AppLocalizations.of(context).brokerPortal,

                  onPressed: () => _navigateToBrokerPortal(context),
                  icon: const Icon(Icons.admin_panel_settings_outlined),
                  color: AppTheme.textPrimary,
                ),
              ],
            ),
            SliverToBoxAdapter(child: _buildSearchBar(context, ref)),
            if (searchQuery.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                  child: Text(
                    AppLocalizations.of(context).searchResults,

                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              )
            else ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context).featured,

                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton(
                        onPressed: () => _navigateToListing(context, ref),
                        child: Text(
                          AppLocalizations.of(context).seeAll,
                          style: TextStyle(color: AppTheme.primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 320,
                  child: featuredAsync.when(
                    data: (properties) => ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: properties.length,
                      itemBuilder: (_, index) => _buildFeaturedCard(
                        context,
                        properties[index],
                        width: properties.length == 1
                            ? MediaQuery.of(context).size.width -
                                  (MediaQuery.of(context).size.width * 0.08)
                            : null,
                      ),
                    ),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (_, __) => const Center(child: Text('')),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context).categories,

                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(child: _buildCategories(context, ref)),
            ],
            if (searchQuery.isNotEmpty)
              searchResults.when(
                data: (properties) {
                  if (properties.isEmpty) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            const Icon(
                              Icons.search_off,
                              size: 64,
                              color: AppTheme.textTertiary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              AppLocalizations.of(
                                context,
                              ).noPropertiesFound(searchQuery),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, index) => PropertyCard(
                        property: properties[index],
                        onTap: () =>
                            _navigateToDetail(context, properties[index]),
                      ),
                      childCount: properties.length,
                    ),
                  );
                },
                loading: () => const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (_, __) =>
                    const SliverFillRemaining(child: Center(child: Text(''))),
              )
            else
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).recentListings,

                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      _buildRecentListings(context, ref),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.findYour,

                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: AppTheme.textTertiary),
              ),
              Text(
                l10n.perfectHome,

                style: Theme.of(context).textTheme.displayMedium,
              ),
            ],
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.glassBorder),
              color: AppTheme.glassLight,
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, WidgetRef ref) {
    final hintStyle = TextStyle(color: AppTheme.textTertiary, fontSize: 14);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GlassContainer(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            TextField(
              style: const TextStyle(color: AppTheme.textPrimary),
              focusNode: _searchFocusNode,
              controller: _searchCtrl,
              onChanged: (value) =>
                  ref.read(searchProvider.notifier).state = value,
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                // Hide default prefix icon to handle it custom or leave it here
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppTheme.textTertiary,
                ),
                // Leave hintText completely empty when focused or when text is typed
                // hintText: _hasFocus || ref.watch(searchProvider).isNotEmpty ? '' : null,
                suffixIcon: ref.watch(searchProvider).isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          ref.read(searchProvider.notifier).state = '';
                          _searchCtrl.text = '';
                          _searchFocusNode.unfocus();
                        },
                        icon: Icon(Icons.clear, color: AppTheme.textTertiary),
                      )
                    : SizedBox.shrink(),
              ),
            ),
            // Custom Animated Hint Text layer
            if (!_hasFocus && ref.watch(searchProvider).isEmpty)
              Positioned(
                left: 48, // Aligns perfectly next to the prefix icon
                child: IgnorePointer(
                  // Allows taps to pass through to the TextField
                  child: SizedBox(
                    width: 250,
                    child: DefaultTextStyle(
                      style: hintStyle,
                      child: AnimatedTextKit(
                        repeatForever: true,
                        pause: const Duration(milliseconds: 1000),
                        animatedTexts: [
                          TypewriterAnimatedText(
                            AppLocalizations.of(context).hintSearchByLocation,

                            speed: const Duration(milliseconds: 80),
                          ),
                          TypewriterAnimatedText(
                            AppLocalizations.of(context).hintSearchByProperty,

                            speed: const Duration(milliseconds: 80),
                          ),
                          TypewriterAnimatedText(
                            AppLocalizations.of(context).hintSearchByVilla,

                            speed: const Duration(milliseconds: 80),
                          ),
                        ],
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

  Widget _buildFeaturedCard(
    BuildContext context,
    Property property, {
    double? width,
  }) {
    return GestureDetector(
      onTap: () => _navigateToDetail(context, property),
      child: Container(
        width: width ?? 280,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: GlassContainer(
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (property.images.isNotEmpty)
                Expanded(
                  flex: 4,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: _buildCardImage(
                      property.images.first,
                    ), // Use the dynamic loader here
                  ),
                ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        property.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppTheme.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 12,
                            color: AppTheme.textTertiary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              property.location,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppTheme.textTertiary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        FormatHelpers.formatPriceWithUnit(
                          property.price,
                          property.type,
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppTheme.primaryColor,
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

  // Add this helper method directly inside your _HomePageState class
  Widget _buildCardImage(String imageStr) {
    if (imageStr.startsWith('data:image')) {
      try {
        final base64Data = imageStr.split(',').last;
        return Image.memory(
          base64Decode(base64Data),
          width: double.infinity,
          fit: BoxFit.cover,
        );
      } catch (e) {
        return Container(
          color: AppTheme.surfaceColor,
          child: const Icon(Icons.broken_image, color: AppTheme.textTertiary),
        );
      }
    }

    return CachedNetworkImage(
      imageUrl: imageStr,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(color: AppTheme.surfaceColor),
      errorWidget: (_, __, ___) => Container(
        color: AppTheme.surfaceColor,
        child: const Icon(Icons.broken_image, color: AppTheme.textTertiary),
      ),
    );
  }

  Widget _buildCategories(BuildContext context, WidgetRef ref) {
    final categories = [
      {'icon': Icons.apartment, 'label': 'Apartment', 'type': null},
      {'icon': Icons.home_work_outlined, 'label': 'For Sale', 'type': 'sale'},
      {
        'icon': Icons.meeting_room_outlined,
        'label': 'For Rent',
        'type': 'rent',
      },
      {'icon': Icons.villa_outlined, 'label': 'Villa', 'type': null},
    ];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        itemBuilder: (_, index) {
          final cat = categories[index];
          return GestureDetector(
            onTap: () {
              if (cat['type'] != null) {
                ref
                    .read(propertyFilterProvider.notifier)
                    .setType(cat['type'] as String);
                _navigateToListing(context, ref);
              } else {
                _navigateToListing(context, ref);
              }
            },
            child: Container(
              width: 80,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: GlassContainer(
                // padding: const EdgeInsets.all(12),
                borderRadius: BorderRadius.circular(14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      cat['icon'] as IconData,
                      color: AppTheme.primaryColor,
                      size: 28,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cat['label'] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecentListings(BuildContext context, WidgetRef ref) {
    final propertiesAsync = ref.watch(propertiesProvider);
    return propertiesAsync.when(
      data: (properties) => Column(
        children: properties
            .map(
              (p) => PropertyCard(
                property: p,
                onTap: () => _navigateToDetail(context, p),
              ),
            )
            .toList(),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Failed to load listings')),
    );
  }

  void _navigateToListing(BuildContext context, WidgetRef ref) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ListingPage()));
  }

  void _navigateToDetail(BuildContext context, Property property) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => DetailPage(propertyId: property.id)),
    );
  }
}
