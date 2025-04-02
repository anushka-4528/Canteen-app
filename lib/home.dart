import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> orders = [
    {'id': 1, 'item': 'Burger', 'quantity': 2, 'status': 'Pending', 'time': '12:30 PM'},
    {'id': 2, 'item': 'Pizza', 'quantity': 1, 'status': 'Preparing', 'time': '12:35 PM'},
    {'id': 3, 'item': 'Pasta', 'quantity': 3, 'status': 'Pending', 'time': '12:40 PM'},
  ];

  Map<int, String> previousStatuses = {}; // For undo tracking

  void updateOrderStatus(int index, String newStatus) {
    setState(() {
      if (newStatus == 'Ready for Pickup') {
        previousStatuses[index] = orders[index]['status']; // Save previous status only on Ready
      }
      orders[index]['status'] = newStatus;
    });
  }

  void undoStatusChange(int index) {
    setState(() {
      if (previousStatuses.containsKey(index)) {
        orders[index]['status'] = previousStatuses[index];
        previousStatuses.remove(index);
      }
    });
  }

  void cancelOrder(int index) {
    setState(() {
      orders.removeAt(index);
      previousStatuses.remove(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: Text("Canteen Orders", style: TextStyle(color: Colors.white)),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue.shade700),
              child: Text("Menu", style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text("Orders"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: EdgeInsets.all(10),
            color: Colors.blue.shade700,
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Search orders...",
                prefixIcon: Icon(Icons.search, color: Colors.blue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                var order = orders[index];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  elevation: 2,
                  child: ListTile(
                    leading: PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, color: Colors.grey),
                      onSelected: (String value) {
                        if (value == 'Cancel Order') {
                          cancelOrder(index);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(value: 'Cancel Order', child: Text('Cancel Order')),
                      ],
                    ),
                    title: Text(order['item'], style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Quantity: ${order['quantity']}'),
                        Text('Time: ${order['time']}'),
                        Text('Status: ${order['status']}', style: TextStyle(color: Colors.grey.shade700)),
                      ],
                    ),
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (order['status'] == 'Pending')
                          ElevatedButton(
                            onPressed: () => updateOrderStatus(index, 'Preparing'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text("Preparing", style: TextStyle(color: Colors.white)),
                          ),
                        if (order['status'] == 'Preparing')
                          ElevatedButton(
                            onPressed: () => updateOrderStatus(index, 'Ready for Pickup'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text("Ready", style: TextStyle(color: Colors.white)),
                          ),
                        if (previousStatuses.containsKey(index))
                          TextButton(
                            onPressed: () => undoStatusChange(index),
                            child: Text("Undo", style: TextStyle(color: Colors.red)),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(40, 20),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
