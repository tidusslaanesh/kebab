import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizza Ordering App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PizzaOrderPage(),
    );
  }
}

class PizzaOrderPage extends StatefulWidget {
  const PizzaOrderPage({Key? key}) : super(key: key);

  @override
  _PizzaOrderPageState createState() => _PizzaOrderPageState();
}

class _PizzaOrderPageState extends State<PizzaOrderPage> {
  int _selectedPizzaIndex = -1;

  final List<Map<String, dynamic>> _pizzas = [
    {'name': 'Margherita', 'price': 8.99},
    {'name': 'Pepperoni', 'price': 10.99},
    {'name': 'Vegetarian', 'price': 9.99},
    {'name': 'Supreme', 'price': 12.99},
  ];

  List<Map<String, dynamic>> _cart = [];

  bool _extraCheese = false;
  bool _garlic = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pizza Ordering App'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Choose your pizza:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _pizzas.length,
              itemBuilder: (context, index) {
                final pizza = _pizzas[index];
                return ListTile(
                  title: Text(pizza['name']),
                  trailing: Text('\$${pizza['price']}'),
                  selected: index == _selectedPizzaIndex,
                  onTap: () {
                    _showPizzaDialog(context, index);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                _showCart(context);
              },
              child: Text('View Cart'),
            ),
          ),
        ],
      ),
    );
  }

  void _showPizzaDialog(BuildContext context, int pizzaIndex) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Add ${_pizzas[pizzaIndex]['name']} to Cart'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Select your options:'),
                  Row(
                    children: [
                      Checkbox(
                        value: _extraCheese,
                        onChanged: (value) {
                          setState(() {
                            _extraCheese = value ?? false;
                          });
                        },
                      ),
                      Text('Extra Cheese (\$1.00)'),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _garlic,
                        onChanged: (value) {
                          setState(() {
                            _garlic = value ?? false;
                          });
                        },
                      ),
                      Text('Garlic (\$0.50)'),
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    _addToCart(_pizzas[pizzaIndex]);
                    Navigator.of(context).pop();
                  },
                  child: Text('Add to Cart'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _addToCart(Map<String, dynamic> pizza) {
    final pizzaToAdd = Map<String, dynamic>.from(pizza);
    pizzaToAdd['extraCheese'] = _extraCheese;
    pizzaToAdd['garlic'] = _garlic;
    _cart.add(pizzaToAdd);
    // Reset options for the next selection
    _extraCheese = false;
    _garlic = false;
  }

  void _showCart(BuildContext context) {
    double total = 0;
    _cart.forEach((item) {
      total += item['price'];
      if (item['extraCheese']) {
        total += 1; // Extra cheese costs $1
      }
      if (item['garlic']) {
        total += 0.5; // Garlic costs $0.5
      }
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Shopping Cart'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Selected Items:'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _cart.map((pizza) {
                  return ListTile(
                    title: Text('${pizza['name']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(extraCheeseText(pizza['extraCheese'])),
                        Text(garlicText(pizza['garlic'])),
                      ],
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
              Text('Total Price: \$${total.toStringAsFixed(2)}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  String extraCheeseText(bool extraCheese) {
    return extraCheese ? 'Extra Cheese: Yes' : 'Extra Cheese: No';
  }

  String garlicText(bool garlic) {
    return garlic ? 'Garlic: Yes' : 'Garlic: No';
  }
}
