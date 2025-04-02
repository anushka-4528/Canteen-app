import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionsPage extends StatefulWidget {
  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  List<Map<String, dynamic>> allTransactions = [
    {'name': 'John Doe', 'amount': 120, 'date': DateTime.now().subtract(Duration(days: 0))},
    {'name': 'Jane Smith', 'amount': 250, 'date': DateTime.now().subtract(Duration(days: 1))},
    {'name': 'Mark Wilson', 'amount': 80, 'date': DateTime.now().subtract(Duration(days: 2))},
    {'name': 'Sara Lee', 'amount': 310, 'date': DateTime.now().subtract(Duration(days: 1))},
    {'name': 'Tom Hanks', 'amount': 50, 'date': DateTime.now().subtract(Duration(days: 3))},
  ];

  List<Map<String, dynamic>> filteredTransactions = [];

  String searchQuery = "";
  String selectedDateRange = 'All';
  String selectedAmount = 'All';

  bool showDateOptions = false;
  bool showAmountOptions = false;

  @override
  void initState() {
    super.initState();
    filteredTransactions = List.from(allTransactions);
  }

  void filterTransactions() {
    List<Map<String, dynamic>> temp = allTransactions.where((txn) {
      final matchesSearch = txn['name'].toLowerCase().contains(searchQuery.toLowerCase());

      bool matchesDate = true;
      if (selectedDateRange == '7 Days') {
        matchesDate = txn['date'].isAfter(DateTime.now().subtract(Duration(days: 7)));
      } else if (selectedDateRange == '30 Days') {
        matchesDate = txn['date'].isAfter(DateTime.now().subtract(Duration(days: 30)));
      } else if (selectedDateRange == '60 Days') {
        matchesDate = txn['date'].isAfter(DateTime.now().subtract(Duration(days: 60)));
      }

      bool matchesAmount = true;
      if (selectedAmount == '1-100') {
        matchesAmount = txn['amount'] >= 1 && txn['amount'] <= 100;
      } else if (selectedAmount == '100-300') {
        matchesAmount = txn['amount'] > 100 && txn['amount'] <= 300;
      } else if (selectedAmount == 'Above 300') {
        matchesAmount = txn['amount'] > 300;
      }

      return matchesSearch && matchesDate && matchesAmount;
    }).toList();

    setState(() {
      filteredTransactions = temp;
    });
  }

  Widget buildDropdownBlock({
    required String title,
    required bool expanded,
    required VoidCallback onTap,
    required List<String> options,
    required String selectedValue,
    required Function(String) onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            margin: EdgeInsets.only(right: 10),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
                Icon(expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        if (expanded)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: options.map((opt) {
              return GestureDetector(
                onTap: () {
                  onSelected(opt);
                  onTap();
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: selectedValue == opt ? Colors.blue : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    opt,
                    style: TextStyle(
                      color: selectedValue == opt ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );
            }).toList(),
          )
      ],
    );
  }
  Widget buildFilterButton({
    required String title,
    required bool expanded,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
            Icon(expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Widget buildOptionsBlock({
    required List<String> options,
    required String selectedValue,
    required Function(String) onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: options.map((opt) {
        return GestureDetector(
          onTap: () => onSelected(opt),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: selectedValue == opt ? Colors.blue : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              opt,
              style: TextStyle(
                color: selectedValue == opt ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }


  Widget buildTransactionItem(Map<String, dynamic> txn) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue.shade100,
        child: Icon(Icons.account_circle, color: Colors.blue.shade800),
      ),
      title: Text(txn['name'], style: TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(DateFormat.yMMMd().format(txn['date'])),
      trailing: Text(
        '₹${txn['amount']}',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<Map<String, dynamic>>> groupedTxns = {};
    for (var txn in filteredTransactions) {
      String dayKey = DateFormat.yMMMd().format(txn['date']);
      groupedTxns.putIfAbsent(dayKey, () => []).add(txn);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (val) {
                searchQuery = val;
                filterTransactions();
              },
              decoration: InputDecoration(
                hintText: 'Search transactions',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),

          // Filter Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filter Buttons Row
                Row(
                  children: [
                    buildFilterButton(
                      title: 'Date',
                      expanded: showDateOptions,
                      onTap: () {
                        setState(() {
                          showDateOptions = !showDateOptions;
                          showAmountOptions = false;
                        });
                      },
                    ),
                    buildFilterButton(
                      title: 'Amount',
                      expanded: showAmountOptions,
                      onTap: () {
                        setState(() {
                          showAmountOptions = !showAmountOptions;
                          showDateOptions = false;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 8),
                if (showDateOptions)
                  buildOptionsBlock(
                    options: ['All', '7 Days', '30 Days', '60 Days'],
                    selectedValue: selectedDateRange,
                    onSelected: (val) {
                      setState(() {
                        selectedDateRange = val;
                        showDateOptions = false;
                        filterTransactions();
                      });
                    },
                  ),
                if (showAmountOptions)
                  buildOptionsBlock(
                    options: ['All', '1-100', '100-300', 'Above 300'],
                    selectedValue: selectedAmount,
                    onSelected: (val) {
                      setState(() {
                        selectedAmount = val;
                        showAmountOptions = false;
                        filterTransactions();
                      });
                    },
                  ),
              ],
            ),
          ),


          SizedBox(height: 10),

          // Transactions List
          Expanded(
            child: ListView(
              children: groupedTxns.entries.map((entry) {
                int totalAmount = entry.value.fold(0, (sum, txn) => sum + txn['amount'] as int);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.grey[200],
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(entry.key, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('₹$totalAmount', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    ...entry.value.map(buildTransactionItem).toList(),
                    Divider(thickness: 1),
                  ],
                );
              }).toList(),
            ),
          ),

        ],

      ),
    );
  }
}
