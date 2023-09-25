import 'package:flutter/material.dart';

class RecipeDetail extends StatelessWidget {
  final Map<String, dynamic> recipe;

  RecipeDetail(this.recipe);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['ime']),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'images/${recipe['slika']}',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20.0),
            Text(
              'Opis:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              recipe['opis'],
              style: TextStyle(fontSize: 16.0),
            ),
            // Dodajte ostale informacije o receptu ovde...
          ],
        ),
      ),
    );
  }
}
