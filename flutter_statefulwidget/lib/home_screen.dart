import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_statefulwidget/screens/add_car_screen.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => HomeState();
}

class Car {
  final String id;
  final String name;
  final String brand;
  final String detail;
  final String coverImage;
  final String price;
  final String engine;
  final int rating;
  final bool fav; // Add fav property

  Car({
    required this.id,
    required this.name,
    required this.brand,
    required this.detail,
    required this.coverImage,
    required this.price,
    required this.engine,
    required this.rating,
    required this.fav, // Add to constructor
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['_id'],
      name: json['name'],
      brand: json['brand'],
      detail: json['detail'],
      coverImage: json['coverimage'],
      price: json['price'],
      engine: json['engine'],
      rating: json['rating'],
      fav: json['fav'] ?? false, // Parse fav from JSON
    );
  }
}

class HomeState extends State<HomeScreen> {
  List<Car> cars = [];
  List<Car> filteredCars = [];
  Set<String> favoriteCars = {};
  Set<String> loadingFavorites = {};
  bool isLoading = true;
  String? error;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchCars();
  }

  Future<void> fetchCars() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/cars'),
      );

      if (response.statusCode == 200) {
        try {
          if (response.body.isNotEmpty) {
            final List<dynamic> data = json.decode(response.body);
            setState(() {
              cars = data.map((json) => Car.fromJson(json)).toList();
              // Initialize favoriteCars with IDs of cars that have fav: true
              favoriteCars =
                  cars.where((car) => car.fav).map((car) => car.id).toSet();
              filteredCars = cars;
              isLoading = false;
            });
          } else {
            setState(() {
              error = 'Response body is empty';
              isLoading = false;
            });
          }
        } catch (e) {
          setState(() {
            error = 'Error decoding response: $e';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          error = 'Failed to load cars: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error connecting to server: $e';
        isLoading = false;
      });
    }
  }

  // Rest of the code remains the same...
  // (addToFavorites, removeFromFavorites, toggleFavorite, and build methods stay unchanged)

  Future<void> addToFavorites(String carId) async {
    setState(() {
      loadingFavorites.add(carId);
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/cars/fav/$carId'),
      );

      if (response.statusCode == 200) {
        setState(() {
          favoriteCars.add(carId);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add favorite: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding favorite: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        loadingFavorites.remove(carId);
      });
    }
  }

  Future<void> removeFromFavorites(String carId) async {
    setState(() {
      loadingFavorites.add(carId);
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/unfav/$carId'),
      );

      if (response.statusCode == 200) {
        setState(() {
          favoriteCars.remove(carId);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove favorite: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error removing favorite: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        loadingFavorites.remove(carId);
      });
    }
  }

  Future<void> toggleFavorite(String carId) async {
    if (favoriteCars.contains(carId)) {
      await removeFromFavorites(carId);
    } else {
      await addToFavorites(carId);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              error!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: fetchCars,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: fetchCars,
        child: filteredCars.isEmpty
            ? const Center(child: Text('No cars found'))
            : ListView.builder(
                itemCount: filteredCars.length,
                itemBuilder: (context, i) {
                  return Card(
                    margin: const EdgeInsets.all(8),
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            // Car Image
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4)),
                              child: Image.network(
                                filteredCars[i].coverImage,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return SizedBox(
                                    height: 200,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 200,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.error),
                                  );
                                },
                              ),
                            ),
                            // Favorite Icon
                            Positioned(
                              top: 10,
                              right: 10,
                              child: loadingFavorites
                                      .contains(filteredCars[i].id)
                                  ? Container(
                                      width: 48,
                                      height: 48,
                                      padding: const EdgeInsets.all(12),
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : IconButton(
                                      icon: Icon(
                                        favoriteCars
                                                .contains(filteredCars[i].id)
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: favoriteCars
                                                .contains(filteredCars[i].id)
                                            ? Colors.red
                                            : Colors.white,
                                        size: 28,
                                      ),
                                      onPressed: () =>
                                          toggleFavorite(filteredCars[i].id),
                                    ),
                            ),
                          ],
                        ),
                        // Rest of your card content remains the same
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        filteredCars[i].brand,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        filteredCars[i].name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: List.generate(
                                      5,
                                      (index) => Icon(
                                        Icons.star,
                                        size: 20,
                                        color: index < filteredCars[i].rating
                                            ? Colors.amber
                                            : Colors.grey[300],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                filteredCars[i].detail,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Engine: ${filteredCars[i].engine}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Text(
                                    filteredCars[i].price,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCarScreen()),
          );
          if (result == true) {
            fetchCars();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
