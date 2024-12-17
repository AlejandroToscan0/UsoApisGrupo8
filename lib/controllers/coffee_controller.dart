import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/coffee_model.dart';

class CoffeeController {
  static const String _apiUrl = 'https://api.sampleapis.com/coffee/hot';

  // Lista local para almacenar los cafés después de cargarlos de la API
  List<Coffee> _coffees = [];

  // Obtener todos los cafés desde la API y almacenar en la lista local
  Future<List<Coffee>> fetchCoffees() async {
    final response = await http.get(Uri.parse(_apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      _coffees = data.map((json) => Coffee.fromJson(json)).toList();
      return _coffees;
    } else {
      throw Exception('Error al cargar los datos de la API');
    }
  }

  // Obtener la lista local actualizada
  List<Coffee> getCoffees() => _coffees;

  // Agregar un nuevo café
  void addCoffee(Coffee coffee) {
    _coffees.add(coffee);
  }

  // Actualizar un café existente
  void updateCoffee(int id, String newTitle, String newDescription, String newImageUrl) {
    final index = _coffees.indexWhere((c) => c.id == id);
    if (index != -1) {
      _coffees[index] = Coffee(
        id: id,
        title: newTitle,
        description: newDescription,
        imageUrl: newImageUrl,
      );
    }
  }

  // Eliminar un café
  void deleteCoffee(int id) {
    _coffees.removeWhere((c) => c.id == id);
  }
}
