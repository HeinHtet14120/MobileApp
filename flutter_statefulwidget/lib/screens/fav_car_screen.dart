import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FavCarScreen extends StatefulWidget {
  const FavCarScreen({super.key});

  @override
  State<StatefulWidget> createState() => FavCarScreenState();
}

class FavCar {
  final String id;
  final String name;
  final String brand;
  final String coverImage;
  final String engine;
  final int rating;

  FavCar({
    required this.id,
    required this.name,
    required this.brand,
    required this.coverImage,
    required this.engine,
    required this.rating,
  });

  factory FavCar.fromJson(Map<String, dynamic> json) {
    return FavCar(
      id: json['_id'],
      name: json['name'],
      brand: json['brand'],
      coverImage: json['coverimage'],
      engine: json['engine'],
      rating: json['rating'],
    );
  }
}

class FavCarScreenState extends State<FavCarScreen> {
  List<FavCar> favCars = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFavCars();
  }

  Future<void> fetchFavCars() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:3000/api/cars/fav'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          favCars = data.map((json) => FavCar.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load favorite cars');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error - you might want to show a snackbar or error message
      print('Error fetching favorite cars: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : favCars.isEmpty
              ? const Center(child: Text('No favorite cars found'))
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: favCars.length,
                  itemBuilder: (context, index) {
                    final car = favCars[index];
                    return Card(
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(car.coverImage),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  car.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  car.brand,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  children: [
                                    ...List.generate(
                                      5,
                                      (index) => Icon(
                                        index < car.rating
                                            ? Icons.star
                                            : Icons.star_border,
                                        size: 16,
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
