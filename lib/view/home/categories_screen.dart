import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Categories'),
      ),
      body: const Center(
        child: Text(
          'Choose your favorite category here!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
