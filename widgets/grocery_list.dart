import 'package:flutter/material.dart';
import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );

    if (newItem == null) {
      return;
    }

    setState(() => _groceryItems.add(newItem));
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text("No Items Available",
          style: TextStyle(
            fontSize: 20,
          )),
    );

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (context, index) => Dismissible(
          key: ValueKey(_groceryItems[index]),
          onDismissed: (direction) {
            // Remove the item from the data source.
            setState(() {
              _groceryItems.remove(_groceryItems[index]);
            });

            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Item removed")));
          },
          child: ListTile(
            title: Text(_groceryItems[index].name),
            leading: Container(
                width: 24,
                height: 24,
                color: _groceryItems[index].category.color),
            trailing: Text(
              _groceryItems[index].quantity.toString(),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Your Groceries"), actions: [
        IconButton(onPressed: _addItem, icon: const Icon(Icons.add)),
      ]),
      body: content,
    );
  }
}
