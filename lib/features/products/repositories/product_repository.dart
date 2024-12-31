import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class ProductRepository {
  Future<List<dynamic>> fetchProducts() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw Exception('No Internet Connection');
    }

    final response =
        await http.get(Uri.parse('https://dummyjson.com/products'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['products'] != null && data['products'].isNotEmpty) {
        return data['products'];
      } else {
        throw Exception('No Data Found');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }
}
