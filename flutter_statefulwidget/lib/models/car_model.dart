class Car {
  final String id;
  final String name;
  final String detail;
  final String coverImage;
  final String price;
  final String engine;
  final int rating;
  final bool fav;

  Car({
    required this.id,
    required this.name,
    required this.detail,
    required this.coverImage,
    required this.price,
    required this.engine,
    required this.rating,
    required this.fav,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['_id'] ?? '', // Provide a default value if null
      name: json['name'] ?? 'Unknown', // Fallback to 'Unknown' if null
      detail: json['detail'] ?? '',
      coverImage: json['coverimage'] ?? '',
      price: json['price'] ?? 'N/A',
      engine: json['engine'] ?? '',
      rating: json['rating'] ?? 0,
      fav: json['fav'] ?? false,
    );
  }
}
