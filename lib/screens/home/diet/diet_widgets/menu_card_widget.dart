import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart'; // For rootBundle
import './utils/capitalize_words.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


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
                  height: 34,
                  width: 90,
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
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
  TextEditingController foodController = TextEditingController(text: menuItem['food_name']);
  TextEditingController quantityController = TextEditingController(text: menuItem['quantity']);
  String? selectedUnit; // No default unit selected
  File? uploadedImage;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            contentPadding: const EdgeInsets.all(16),
            title: Container(
              height: 40, // Provide enough height for the title and button
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Centered Title with Rounded Background
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: const Text(
                        'Diet Upload',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  // Small Close Button on the top right
                  Positioned(
                    right: 0,
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red.withOpacity(0.2),
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.close, color: Colors.red),
                        iconSize: 15, // Make the button smaller
                        padding: const EdgeInsets.all(4), // Adjust padding for a smaller size
                      ),
                    ),
                  ),
                ],
              ),
            ),
            content: Container(
              width: 500, // Set desired width
              child: SingleChildScrollView(
                // Make the entire dialog scrollable
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Circular Image at the top (remains unchanged)
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(
                          imageExistenceCache[imagePath] == true
                              ? imagePath
                              : 'assets/images/diet/menu/oats with milk and fruits.jpg', // Fallback image if not found
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Food name TextBox (now pre-filled with selected food name)
                    const Text('Food Item', style: TextStyle(fontWeight: FontWeight.w600)),
                    TextField(
                      controller: foodController,
                      decoration: InputDecoration(
                        hintText: 'Enter food name',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue.withOpacity(0.6), width: 1.5),
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 12),

                    // Quantity and Units row
                    Row(
                      children: [
                        // Quantity field
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Quantity', style: TextStyle(fontWeight: FontWeight.w600)),
                              Container(
                                height: 50,
                                child: TextField(
                                  controller: quantityController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: 'Enter quantity',
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.blue.withOpacity(0.6), width: 1.5),
                                    ),
                                    border: const OutlineInputBorder(),
                                  ),
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Units dropdown field
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Units', style: TextStyle(fontWeight: FontWeight.w600)),
                              Container(
                                child: DropdownButtonFormField<String>(
                                  value: selectedUnit,
                                  hint: const Text(
                                    'gms',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedUnit = newValue!;
                                    });
                                  },
                                  items: <String>['gms', 'ml', 'pcs', 'cup', 'tsp']
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                    );
                                  }).toList(),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4.0), // Match border radius with quantity field
                                      borderSide: BorderSide(color: Colors.blue.withOpacity(0.6), width: 1.5),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4.0), // Match border radius with quantity field
                                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4.0), // Match border radius with quantity field
                                      borderSide: BorderSide(color: Colors.blue.withOpacity(0.6), width: 1.5),
                                    ),
                                  ),
                                  dropdownColor: Colors.white,
                                  style: const TextStyle(fontSize: 14, color: Colors.black),
                                  icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
                                  isExpanded: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Image upload (scrollable)
                    const Text('Image', style: TextStyle(fontWeight: FontWeight.w600)),
                    GestureDetector(
                      onTap: () async {
                        try {
                          final picker = ImagePicker();
                          final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                          if (pickedFile != null) {
                            setState(() {
                              uploadedImage = File(pickedFile.path);
                            });
                          }
                        } catch (e) {
                          print("Error picking image: $e");
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: uploadedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  uploadedImage!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Center(child: Text('Click to Upload Image')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Center(
                child: TextButton(
                  onPressed: () {
                    // Handle image upload and save
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    side: const BorderSide(color: Colors.green), // Green border
                    backgroundColor: Colors.green.withOpacity(0.2), // Light green opacity
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Upload',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green, // Dark green text
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}




}