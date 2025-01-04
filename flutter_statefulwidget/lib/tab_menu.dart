import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'user_profile_screen.dart';
import './screens/brands_screen.dart';
import './screens/fav_car_screen.dart';

class TabMenu extends StatelessWidget {
  final String username;

  const TabMenu({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/carlogo.png', // Replace with your logo's path
                height: 30, // Adjust the height
              ),
              const SizedBox(width: 8), // Spacing between logo and text
              const Text('Hein Htet'),
            ],
          ),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home), text: 'Home'),
              Tab(icon: Icon(Icons.category), text: 'Brands'),
              Tab(icon: Icon(Icons.favorite), text: 'Favorites'),
              Tab(icon: Icon(Icons.person), text: 'Profile'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const HomeScreen(),
            const BrandsScreen(),
            const FavCarScreen(),
            UserProfileScreen(username: username),
          ],
        ),
      ),
    );
  }
}
