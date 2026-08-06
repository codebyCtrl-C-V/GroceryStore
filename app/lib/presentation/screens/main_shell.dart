import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../providers/cart_provider.dart';
import '../providers/user_provider.dart';
import 'home/home_screen.dart';
import 'search/search_screen.dart';
import 'news/news_screen.dart';
import 'chatbot/chatbot_screen.dart';
import 'profile/profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const NewsScreen(),
    const ChatbotScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Load cart on start if logged in
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = context.read<UserProvider>();
      if (userProvider.isLoggedIn) {
        context.read<CartProvider>().fetchCart(token: userProvider.accessToken);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().itemCount;
    final isLoggedIn = context.watch<UserProvider>().isLoggedIn;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.shopping_basket_rounded, size: 28),
            const SizedBox(width: 8),
            Text(
              _selectedIndex == 0
                  ? 'Grocery Store'
                  : _selectedIndex == 1
                      ? 'Tìm kiếm'
                      : _selectedIndex == 2
                          ? 'Tin tức'
                          : _selectedIndex == 3
                              ? 'Trợ lý AI'
                              : 'Cá nhân',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          // Cart Icon with badge
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  if (isLoggedIn) {
                    Navigator.pushNamed(context, '/cart');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Vui lòng đăng nhập để xem giỏ hàng!')),
                    );
                    Navigator.pushNamed(context, '/login');
                  }
                },
              ),
              if (cartCount > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      cartCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Tìm kiếm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper_outlined),
            activeIcon: Icon(Icons.newspaper),
            label: 'Tin tức',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Trợ lý AI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Cá nhân',
          ),
        ],
      ),
    );
  }
}
