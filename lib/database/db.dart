import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

Future<List<Map<String, dynamic>>> getAllSalads() async {
  final response = await http.get(Uri.parse('http://localhost/phpsalate/saladsAll.php'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.cast<Map<String, dynamic>>();
  } else {
    throw Exception('Failed to load salads');
  }
}


Future<List<String>> loadCategories() async {
  final String data = await rootBundle.loadString('assets/categories.json');
  final List<dynamic> jsonList = json.decode(data);

  List<String> categories = [];
  for (var item in jsonList) {
    categories.add(item['name']);
  }

  return categories;
}

