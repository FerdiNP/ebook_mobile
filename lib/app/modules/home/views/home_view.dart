import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../profile/profile_view.dart';


const _mainColor = Color(0xFFCDE7BE);


class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

    @override
  Widget build(BuildContext context) {
    final _selectedColor = Color(0xFF181919);
    final _unselectedColor = Colors.white;
    final _selectedBackgroundColor = Color(0xFFCDE7BE);
    final _unselectedBackgroundColor = Color(0xFF181919);
    final _borderColor = Color(0xFFCDE7BE);

    return DefaultTabController(
      length: 3, // Jumlah Tab
      child: Scaffold(
        backgroundColor: _unselectedBackgroundColor,
        appBar: AppBar(
          elevation: 0.0,
          title: Text(
            'Good Afternoon',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                // Menavigasi ke halaman profil
                Get.toNamed('/profile');
              },
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/profile-picture.png'),
              ),
            ),
            SizedBox(width: 16),
          ],
          backgroundColor: _unselectedBackgroundColor,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(170.0),
            child: Column(
              children: [
                circularBookCovers(),
                TabBar(
                  dividerColor: Colors.transparent,
                  isScrollable: true,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: _selectedBackgroundColor, // Warna Tab Selected
                  ),
                  indicatorSize: TabBarIndicatorSize.label, // Ukuran Indicator
                  labelColor: _selectedColor, // Warna Label Selected
                  unselectedLabelColor: _unselectedColor, // Warna Label Unselected
                  tabAlignment: TabAlignment.start,
                  tabs: [
                    // Trending Tab
                    Tab(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: _selectedBackgroundColor,
                            width: 1,
                          ), // Border
                          color: null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.local_fire_department, size: 18),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                "Trending",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // 5-Minutes Read Tab
                    Tab(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: _borderColor,
                            width: 1,
                          ),
                          color: null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.book, size: 18),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                "5-Minutes Read",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Quick Read Tab
                    Tab(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: _borderColor,
                            width: 1,
                          ),
                          color: null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.headset, size: 18),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                "Quick",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              // Trending Tab
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bookListSection(
                      title: 'Trending',
                      books: ['The Good Guy', 'Futurama', 'Creative Exploration'],
                    ),
                    bookListSection(
                      title: '5-Minutes Read',
                      books: ['Explore Creativity', 'Futurama', 'Norse Mythology'],
                    ),
                    bookListSection(
                      title: 'For You',
                      books: ['The Good Guy', 'Futurama', 'Creative Exploration'],
                    ),
                  ],
                ),
              ),
              // 5-Minutes Read Tab
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bookListSection(
                      title: '5-Minutes Read',
                      books: ['Explore Creativity', 'Futurama', 'Norse Mythology'],
                    ),
                  ],
                ),
              ),
              // Quick Read Tab
              Center(
                child: Text('Quick Read Section', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
            BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'Library'),
          ],
        ),
      ),
    );
  }

  Widget circularBookCovers() {
    final List<Map<String, String>> authors = [
      {
        'name': 'Royryan Mercado',
        'image': 'assets/images/circle.png',
      },
      {
        'name': 'Neil Gaiman',
        'image': 'assets/images/circle.png',
      },
      {
        'name': 'Mark McAllister',
        'image': 'assets/images/circle.png',
      },
      {
        'name': 'Michael Douglas',
        'image': 'assets/images/circle.png',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 90,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: authors.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  // Circular Image Avatar
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.greenAccent.withOpacity(0.2),
                    child: ClipOval(
                      child: CircleAvatar(
                        radius: 28,
                        backgroundImage: AssetImage(authors[index]['image']!),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  // Author Name Text
                  Text(
                    authors[index]['name']!,
                    style: TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget bookListSection({required String title, required List<String> books}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Text('Show all', style: TextStyle(color: _mainColor)),
                  SizedBox(width: 4), // Jarak antara teks dan ikon
                  Icon(
                    Icons.arrow_forward, // Ikon panah kanan
                    color: _mainColor, // Warna ikon
                    size: 18, // Ukuran ikon
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          // Horizontal list of books
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: books.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        height: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/cover.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        books[index],
                        style: TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}

