import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_form/services/language_service.dart';
import 'package:test_form/shop_screan.dart';
import 'package:test_form/favorite_screen.dart';
import 'package:test_form/login.dart';
import 'package:test_form/setting_screen.dart';
import 'package:test_form/translations/app_translations.dart';
import 'widgets/bottom_navigation.dart';
import 'package:test_form/form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _translate(String key){
    try {
      final languageService = context.watch<LanguageService>();
      return AppTranslations.translate(key, languageService.currentLocale.languageCode);
    } catch (e) {
      return key;
    }
  }

  List<Map<String, String>> get imgList => [
    {'title': _translate('oil_paintings'), 'image': 'assets/9.jpg'},
    {'title': _translate('museums'), 'image': 'assets/12.jpg'},
    {'title': _translate('wall_arts'), 'image': 'assets/17.jpg'},
    {'title': _translate('sculptures'), 'image': 'assets/6.jpg'},
    {'title': _translate('photography'), 'image': 'assets/10.jpg'},
    {'title': _translate('digital_art'), 'image': 'assets/11.jpg'},
  ];

 List<Map<String, String>> get galleries => [
    {'title': _translate('oil_paintings'), 'image': 'assets/pic.jpg'},
    {'title': _translate('museums'), 'image': 'assets/pic3.jpg'},
    {'title': _translate('wall_arts'), 'image': 'assets/pic4.jpg'},
    {'title': _translate('sculptures'), 'image': 'assets/pic2.jpg'},
    {'title': _translate('photography'), 'image': 'assets/pic6.jpg'},
    {'title': _translate('digital_art'), 'image': 'assets/pic5.jpg'},
  ];

  List<Map<String, String>> get fullScreenGalleries => [
    {'title': _translate('oil_paintings'), 'image': 'assets/1.jpg'},
    {'title': _translate('museums'), 'image': 'assets/2.jpg'},
    {'title': _translate('wall_arts'), 'image': 'assets/3.jpg'},
    {'title': _translate('sculptures'), 'image': 'assets/4.jpg'},
    {'title': _translate('photography'), 'image': 'assets/5.jpg'},
    {'title': _translate('digital_art'), 'image': 'assets/1.jpeg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 241, 246),
  
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.orange,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Illustrations',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        // backgroundColor: Colors.grey[50],
              backgroundColor: const Color.fromARGB(255, 237, 241, 246),

        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        // Add SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subtitlegle drive
              Text(
                'CURATED GALLERIES',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 20),

              // Gallery grid
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: galleries.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 140,
                      margin: EdgeInsets.only(
                        right: index == galleries.length - 1 ? 0 : 15,
                      ),
                      child: _buildGalleryCard(galleries[index]),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Full screen image builder
              SizedBox(
                height: 230,
                child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: fullScreenGalleries.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(
                        right: index == fullScreenGalleries.length - 1 ? 0 : 15,
                      ),
                      child: _buildFullScreenCard(fullScreenGalleries[index]),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // NEW SECTION: Scrollable Asymmetric Image Grid
              Text(
                'curated_galleries',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 15),

              // Scrollable asymmetric grid layout
              SizedBox(
                height: 240,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: 100, // Large number for infinite-like scrolling
                  itemBuilder: (context, index) {
                    bool isEvenIndex = index % 2 == 0;

                    return Container(
                      width:
                          MediaQuery.of(context).size.width *
                          0.85, // 85% of screen width
                      margin: const EdgeInsets.only(right: 15),
                      child: Row(
                        children: [
                          if (isEvenIndex) ...[
                            // Layout 1: Two small images on left, one large on right
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  // Top left image
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        right: 8,
                                        bottom: 4,
                                      ),
                                      child: _buildFeatureCard(
                                        imgList[(index * 3) % imgList.length],
                                      ),
                                    ),
                                  ),
                                  // Bottom left image
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        right: 8,
                                        top: 4,
                                      ),
                                      child: _buildFeatureCard(
                                        imgList[(index * 3 + 1) %
                                            imgList.length],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Right side - One large image
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin: const EdgeInsets.only(left: 8),
                                child: _buildLargeFeatureCard(
                                  imgList[(index * 3 + 2) % imgList.length],
                                ),
                              ),
                            ),
                          ] else ...[
                            // Layout 2: One large image on left, two small on right
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                child: _buildLargeFeatureCard(
                                  imgList[(index * 3) % imgList.length],
                                ),
                              ),
                            ),
                            // Right side - Two small images stacked
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  // Top right image
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        left: 8,
                                        bottom: 4,
                                      ),
                                      child: _buildFeatureCard(
                                        imgList[(index * 3 + 1) %
                                            imgList.length],
                                      ),
                                    ),
                                  ),
                                  // Bottom right image
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        left: 8,
                                        top: 4,
                                      ),
                                      child: _buildFeatureCard(
                                        imgList[(index * 3 + 2) %
                                            imgList.length],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 120), // Space for bottom navigation
            ],
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  AddIllustrationForm()),
          );
        },
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: const BorderSide(color: Colors.orange, width: 2),
        ),
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: const CustomBottomNavigation(currentIndex: 0)
    );
  }
  // Add this method to your _HomeScreenState class

  // Replace your _buildNavItem method with this:

  Widget _buildGalleryCard(Map<String, String> gallery) {
    return GestureDetector(
      onTap: () {
        print('Tapped on ${gallery['title']}');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image container
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: double.infinity,
                  child: Image.asset(
                    gallery['image']!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.palette,
                          size: 40,
                          color: Colors.grey[600],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Title
          Text(
            gallery['title']!,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Add this new method to your class
  Widget _buildLargeFeatureCard(Map<String, String> gallery) {
    return GestureDetector(
      onTap: () {
        print('Tapped on large feature card ${gallery['title']}');
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                gallery['image']!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.palette,
                            size: 60,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            gallery['title']!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
              ),
              // Title overlay with more space
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gallery['title']!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Featured Collection',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              // Add floating action button on large cards
              Positioned(
                top: 15,
                right: 15,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallCard(Map<String, String> gallery) {
    return GestureDetector(
      onTap: () {
        print('Tapped on small card ${gallery['title']}');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image container
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: double.infinity,
                  child: Image.asset(
                    gallery['image']!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.palette,
                          size: 40,
                          color: Colors.grey[600],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Title
          Text(
            gallery['title']!,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // NEW: Feature card for the grid section
  Widget _buildFeatureCard(Map<String, String> gallery) {
    return GestureDetector(
      onTap: () {
        print('Tapped on feature card ${gallery['title']}');
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                gallery['image']!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Center(
                      child: Icon(
                        Icons.palette,
                        size: 50,
                        color: Colors.grey[600],
                      ),
                    ),
                  );
                },
              ),
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                  ),
                ),
              ),
              // Title overlay
              Positioned(
                bottom: 15,
                left: 15,
                right: 15,
                child: Text(
                  gallery['title']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Full screen card widget
  Widget _buildFullScreenCard(Map<String, String> gallery) {
    return GestureDetector(
      onTap: () {
        print('Tapped on full screen ${gallery['title']}');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 3,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Full screen background image
              Image.asset(
                gallery['image']!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.palette,
                            size: 80,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            gallery['title']!,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              // Gradient overlay for text readability
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
              ),
              // Content overlay
              Positioned(
                bottom: 30,
                left: 10,
                right: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gallery['title']!,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Explore the beauty of ${gallery['title']!.toLowerCase()}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Text(
                            'View Collection',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
