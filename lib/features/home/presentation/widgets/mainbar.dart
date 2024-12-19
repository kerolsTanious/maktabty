import 'package:flutter/material.dart';
import 'package:mktabte/features/check_out/presentation/screen/cart_page.dart';
import 'package:mktabte/features/home/presentation/screens/userwishlistscreen.dart';

import '../screens/allcategriesscreen.dart';
import '../screens/home.dart';
import '../screens/profilescreen.dart';

class MainBar extends StatefulWidget {
  const MainBar({super.key});

  @override
  State<MainBar> createState() => _MainBarState();
}

class _MainBarState extends State<MainBar> {
  int _selectedScreenIndex = 0;

  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activeScreen = const HomePpage();
    if (_selectedScreenIndex == 1) {
      activeScreen = const CategryScreen();
    }
    if (_selectedScreenIndex == 2) {
      activeScreen = const CartPage();
    }
    if (_selectedScreenIndex == 3) {
      activeScreen = const UserWishlist();
    }
    if (_selectedScreenIndex == 4) {
      activeScreen = const ProfileScreen();
    }

    return Scaffold(
      body: Stack(
        children: [
          activeScreen,
          Positioned(
            left: 0,
            right: 0,
            bottom: 18,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: BottomNavigationBar(
                  onTap: _selectScreen,
                  currentIndex: _selectedScreenIndex,
                  unselectedItemColor: const Color.fromARGB(255, 141, 141, 141),
                  selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
                  backgroundColor: Colors.transparent,
                  items: [
                    BottomNavigationBarItem(
                      icon: Image.asset(
                        _selectedScreenIndex == 0
                            ? "assets/images/btns/selected_home_btn_img.png"
                            : "assets/images/btns/home_btn_img.png",
                        height: 20,
                        width: 20,
                      ),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Image.asset(
                        _selectedScreenIndex == 1
                            ? "assets/images/btns/selected_category_btn_img.png"
                            : "assets/images/btns/category_btn_img.png",
                        height: 30,
                        width: 30,
                      ),
                      label: 'Categories',
                    ),
                    BottomNavigationBarItem(
                      icon: Image.asset(
                        _selectedScreenIndex == 2
                            ? "assets/images/btns/selected_cart_btn_img.png"
                            : "assets/images/btns/cart_btn_img.png",
                        height: 20,
                        width: 20,
                      ),
                      label: 'Cart',
                    ),
                    BottomNavigationBarItem(
                      icon: Image.asset(
                        _selectedScreenIndex == 3
                            ? "assets/images/btns/selected_favorite_btn_img.png"
                            : "assets/images/btns/favorite_btn_img.png",
                        height: 30,
                        width: 30,
                      ),
                      label: 'Wishlist',
                    ),
                    BottomNavigationBarItem(
                      icon: Image.asset(
                        _selectedScreenIndex == 4
                            ? "assets/images/btns/selected_person_btn_img.png"
                            : "assets/images/btns/person_btn_img.png",
                        height: 20,
                        width: 20,
                      ),
                      label: 'Profile',
                    ),
                  ],
                  type: BottomNavigationBarType.fixed,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
