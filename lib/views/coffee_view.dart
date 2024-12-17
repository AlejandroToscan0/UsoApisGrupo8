import 'package:flutter/material.dart';
import '../controllers/coffee_controller.dart';
import '../models/coffee_model.dart';

class CoffeeView extends StatefulWidget {
  @override
  _CoffeeViewState createState() => _CoffeeViewState();
}

class _CoffeeViewState extends State<CoffeeView> {
  final CoffeeController _controller = CoffeeController();
  late Future<List<Coffee>> _futureCoffees;

  @override
  void initState() {
    super.initState();
    _refreshCoffees();
  }

  void _refreshCoffees() {
    setState(() {
      _futureCoffees = _controller.fetchCoffees();
    });
  }

  void _showAddDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final imageUrlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Agregar Café'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: InputDecoration(labelText: 'Título')),
            TextField(controller: descriptionController, decoration: InputDecoration(labelText: 'Descripción')),
            TextField(controller: imageUrlController, decoration: InputDecoration(labelText: 'URL de Imagen')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _controller.addCoffee(Coffee(
                id: DateTime.now().millisecondsSinceEpoch,
                title: titleController.text,
                description: descriptionController.text,
                imageUrl: imageUrlController.text,
              ));
              _refreshCoffees();
              Navigator.pop(context);
            },
            child: Text('Agregar'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(Coffee coffee) {
    final titleController = TextEditingController(text: coffee.title);
    final descriptionController = TextEditingController(text: coffee.description);
    final imageUrlController = TextEditingController(text: coffee.imageUrl);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar Café'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: InputDecoration(labelText: 'Título')),
            TextField(controller: descriptionController, decoration: InputDecoration(labelText: 'Descripción')),
            TextField(controller: imageUrlController, decoration: InputDecoration(labelText: 'URL de Imagen')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _controller.updateCoffee(
                coffee.id,
                titleController.text,
                descriptionController.text,
                imageUrlController.text,
              );
              _refreshCoffees();
              Navigator.pop(context);
            },
            child: Text('Actualizar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tipos de Café'),
        backgroundColor: Colors.brown,
      ),
      body: FutureBuilder<List<Coffee>>(
        future: _futureCoffees,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final coffee = snapshot.data![index];
                return Card(
                  child: ListTile(
                    leading: Image.network(coffee.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(coffee.title),
                    subtitle: Text(coffee.description),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: Icon(Icons.edit), onPressed: () => _showEditDialog(coffee)),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _controller.deleteCoffee(coffee.id);
                            _refreshCoffees();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No se encontraron datos'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.brown,
      ),
    );
  }
}
