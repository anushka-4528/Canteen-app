import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int selectedCategoryIndex = 0;

  final List<String> categories = [
    "Beverages",
    "Meals",
    "Ice Cream",
    "Milkshake",
    "Pizza",
  ];

  final List<Map<String, dynamic>> menuItems = [
    {"name": "Coke", "category": "Beverages", "inStock": true},
    {"name": "Pepsi", "category": "Beverages", "inStock": false},

    // Meals (Including Rice Items)
    {"name": "Veg Burger", "category": "Meals", "inStock": true},
    {"name": "Chicken Burger", "category": "Meals", "inStock": true},
    {"name": "Fried Rice", "category": "Meals", "inStock": true},
    {"name": "Veg Biryani", "category": "Meals", "inStock": true},
    {"name": "Chicken Biryani", "category": "Meals", "inStock": false},

    {"name": "Vanilla Ice Cream", "category": "Ice Cream", "inStock": true},
    {"name": "Chocolate Ice Cream", "category": "Ice Cream", "inStock": false},

    {"name": "Oreo Milkshake", "category": "Milkshake", "inStock": true},
    {"name": "Strawberry Milkshake", "category": "Milkshake", "inStock": true},

    {"name": "Margherita Pizza", "category": "Pizza", "inStock": true},
    {"name": "Pepperoni Pizza", "category": "Pizza", "inStock": false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Inventory"),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Row(
        children: [
          // Categories (Left Side)
          Container(
            width: 110, // Increased width for better alignment
            color: Colors.blue.shade50,
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategoryIndex = index;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                    decoration: BoxDecoration(
                      color: selectedCategoryIndex == index
                          ? Colors.blue.shade700
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10), // More squared look
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 22, // Bigger icon
                          backgroundColor: Colors.blue.shade300,
                          child: Icon(
                            Icons.fastfood,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          categories[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: selectedCategoryIndex == index
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Menu Items (Right Side)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: menuItems
                    .where((item) =>
                item["category"] == categories[selectedCategoryIndex])
                    .map((item) => Container(
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 5,
                        offset: Offset(2, 2),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item["name"],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16, // Increased text size
                        ),
                      ),
                      Column(
                        children: [
                          Switch(
                            value: item["inStock"],
                            activeColor: Colors.green,
                            onChanged: (bool value) {
                              setState(() {
                                item["inStock"] = value;
                              });
                            },
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 8),
                            decoration: BoxDecoration(
                              color: item["inStock"]
                                  ? Colors.green.shade100
                                  : Colors.red.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item["inStock"] ? "In Stock" : "Out of Stock",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: item["inStock"]
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
