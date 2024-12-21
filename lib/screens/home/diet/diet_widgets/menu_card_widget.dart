import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart'; // For rootBundle
import './utils/capitalize_words.dart';
import './upload_widgets/upload_widget.dart';


class MenuCard extends StatefulWidget {
  final String time;
  final Map<String, dynamic> details;
  final List<String> imagePaths;

  const MenuCard({
    super.key,
    required this.time,
    required this.details,
    required this.imagePaths,
  });

  @override
  _MenuCardState createState() => _MenuCardState();
}


class _MenuCardState extends State<MenuCard> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late PageController _pageController;
  List<String> currentImagePaths = [];
  Timer? _timer;
  int _currentPageIndex = 0;
  final Map<String, bool> _imageExistenceCache = {}; // Cache for image existence

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    currentImagePaths = List.from(widget.imagePaths);
    _startImageSlideshow();
    _checkImageExistence(); // Check image existence on initialization
  }

  @override
  void didUpdateWidget(MenuCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imagePaths != oldWidget.imagePaths) {
      setState(() {
        _currentPageIndex = 0;
        currentImagePaths = List.from(widget.imagePaths);
        if (_pageController.hasClients && currentImagePaths.isNotEmpty) {
          _pageController.jumpToPage(0);
        }
        _checkImageExistence(); // Check existence on updates
      });
    }
  }

  void _startImageSlideshow() {
    const duration = Duration(seconds: 8);
    _timer?.cancel();
    _timer = Timer.periodic(duration, (timer) {
      if (currentImagePaths.isNotEmpty && mounted) {
        setState(() {
          _currentPageIndex = (_currentPageIndex + 1) % currentImagePaths.length;
        });
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            _currentPageIndex,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  Future<void> _checkImageExistence() async {
    for (var item in (widget.details['menu'] as List)) {
      String imagePath = 'assets/images/diet/menu/${item['item']}.jpg';
      if (!_imageExistenceCache.containsKey(imagePath)) {
        bool exists = await _assetExists(imagePath);
        _imageExistenceCache[imagePath] = exists;
      }
    }
    setState(() {}); // Trigger rebuild after checking existence
  }

  Future<bool> _assetExists(String path) async {
    try {
      final ByteData data = await rootBundle.load(path);
      return data.buffer.asUint8List().isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 165,
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Stack(
              children: [
                if (currentImagePaths.isNotEmpty)
                  SizedBox(
                    height: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: currentImagePaths.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPageIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Image.asset(
                            currentImagePaths[index],
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              print('Error loading image: ${currentImagePaths[index]}');
                              return Container(
                                color: Colors.grey,
                                child: const Center(
                                  child: Text('Image not available'),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                Positioned(
                  // height: 34,
                  // width: 100,
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 50,
                    ),
                    child: Center(
                      child: Text(
                        widget.time,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(
                      _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down_circle,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        ExpandableMenu(
          isExpanded: _isExpanded,
          details: widget.details,
          imageExistenceCache: _imageExistenceCache,
        ),
      ],
    );
  }
}

class ExpandableMenu extends StatelessWidget {
  final bool isExpanded;
  final Map<String, dynamic> details;
  final Map<String, bool> imageExistenceCache;

  const ExpandableMenu({
    Key? key,
    required this.isExpanded,
    required this.details,
    required this.imageExistenceCache,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isExpanded) return SizedBox.shrink();

    return MenuListWidget(
      details: details,
      imageExistenceCache: imageExistenceCache,
    );
  }
}

class MenuListWidget extends StatelessWidget {
  final Map<String, dynamic> details;
  final Map<String, bool> imageExistenceCache;

  const MenuListWidget({
    Key? key,
    required this.details,
    required this.imageExistenceCache,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 247, 247, 247),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Column(
        children: (details['menu'] != null && details['menu'] is List)
            ? (details['menu'] as List).map((menuItem) {
                String imagePath = 'assets/images/diet/menu/${menuItem['food_name']}.jpg';
                return GestureDetector(
                  onTap: () {
                    _showMenuDialog(context, menuItem, imagePath);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 168, 229, 111),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: const Color.fromARGB(255, 233, 245, 230),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    capitalizeWords(menuItem['food_name'] ?? ''),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    menuItem['quantity'] ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: imageExistenceCache[imagePath] == true
                                  ? AssetImage(imagePath)
                                  : AssetImage('assets/images/diet/menu/buttermilk.jpg'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList()
            : [],
      ),
    );
  }

  // Show Dialog on menu item click
  void _showMenuDialog(BuildContext context, dynamic menuItem, String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MenuDialog(
          menuItem: menuItem,
          imagePath: imagePath,
          imageExistenceCache: imageExistenceCache,
        );
      },
    );
  }

}