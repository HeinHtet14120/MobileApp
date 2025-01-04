// lib/screens/add_car_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({super.key});

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  double _rating = 3;
  String? _imagePreviewUrl;

  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _detailController = TextEditingController();
  final _coverImageController = TextEditingController();
  final _priceController = TextEditingController();
  final _engineController = TextEditingController();

  bool _isUnsplashUrl(String url) {
    return url.startsWith('https://images.unsplash.com/');
  }

  void _updateImagePreview(String url) {
    if (_isUnsplashUrl(url)) {
      setState(() {
        _imagePreviewUrl = url;
      });
    } else {
      setState(() {
        _imagePreviewUrl = null;
      });
    }
  }

  Future<void> _submitCar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/cars'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': _nameController.text,
          'brand': _brandController.text,
          'detail': _detailController.text,
          'coverimage': _coverImageController.text,
          'price': '\$${_priceController.text}',
          'engine': _engineController.text,
          'rating': _rating.round(),
        }),
      );

      if (response.statusCode == 201) {
        if (!mounted) return;
        Navigator.pop(context, true);
      } else {
        throw Exception('Failed to add car');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Car'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_imagePreviewUrl != null)
                Container(
                  height: 200,
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(_imagePreviewUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              TextFormField(
                controller: _coverImageController,
                decoration: const InputDecoration(
                  labelText: 'Unsplash Image URL',
                  border: OutlineInputBorder(),
                  helperText: 'Enter a valid Unsplash image URL',
                ),
                onChanged: _updateImagePreview,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter image URL';
                  }
                  if (!_isUnsplashUrl(value)) {
                    return 'Please enter a valid Unsplash URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Car Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter car name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(
                  labelText: 'Brand',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter brand name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _detailController,
                decoration: const InputDecoration(
                  labelText: 'Detail',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter car details' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter price' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _engineController,
                decoration: const InputDecoration(
                  labelText: 'Engine',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty ?? true
                    ? 'Please enter engine details'
                    : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Rating: '),
                  Expanded(
                    child: Slider(
                      value: _rating,
                      min: 0,
                      max: 5,
                      divisions: 5,
                      label: _rating.round().toString(),
                      onChanged: (value) {
                        setState(() {
                          _rating = value;
                        });
                      },
                    ),
                  ),
                  Text(_rating.round().toString()),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitCar,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Add Car'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _detailController.dispose();
    _coverImageController.dispose();
    _priceController.dispose();
    _engineController.dispose();
    super.dispose();
  }
}
