import 'package:flutter/material.dart';
import 'expense.dart'; // Import the ExpensePage

void main() => runApp(ExpenseTrackerApp());

class ExpenseTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Expense Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, Object>> _transactions = []; // Transaction list

  // Add a new transaction
  void _addTransaction(String title, double amount) {
    setState(() {
      _transactions.add({
        'title': title,
        'amount': amount,
        'date': DateTime.now(),
      });
    });
  }

  // Show modal for adding transactions
  void _startAddTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => AddTransaction(_addTransaction),
    );
  }

  // Calculate total payment
  double get _totalPayment {
    return _transactions.fold(0.0, (sum, tx) => sum + (tx['amount'] as double));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            color: Colors.lightBlue[100],
            child: Column(
              children: [
                // App Title
                Container(
                  margin: const EdgeInsets.only(top: 50, bottom: 20),
                  child: const Center(
                    child: Text(
                      'Expense Tracker',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                // Transactions List
                Expanded(
                  child: _transactions.isEmpty
                      ? const Center(
                          child: Text('No transactions added yet!'),
                        )
                      : ListView.builder(
                          itemCount: _transactions.length,
                          itemBuilder: (ctx, index) {
                            final tx = _transactions[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: ListTile(
                                title: Text(tx['title'] as String),
                                subtitle: Text(
                                  (tx['date'] as DateTime).toLocal().toString(),
                                ),
                                trailing: Text(
                                  '\$${tx['amount']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                // View Total Payment
                Container(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Total Payment'),
                          content: Text(
                            '\$${_totalPayment.toStringAsFixed(2)}',
                          ),
                          actions: [
                            TextButton(
                              child: const Text('Close'),
                              onPressed: () => Navigator.of(ctx).pop(),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text('View Total Payment'),
                  ),
                ),
              ],
            ),
          ),
          // Add Transaction Button
          Positioned(
            top: 20,
            right: 20,
            child: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => _startAddTransaction(context),
            ),
          ),
          // Go to Expense Summary Button
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20),
                backgroundColor: Colors.lightBlue[100],
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ExpensePage(totalPayment: _totalPayment),
                  ),
                );
              },
              child: const Icon(Icons.arrow_forward, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

class AddTransaction extends StatefulWidget {
  final Function addTx;

  AddTransaction(this.addTx);

  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  // Submit data for a new transaction
  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.tryParse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount == null || enteredAmount <= 0) {
      return;
    }

    widget.addTx(enteredTitle, enteredAmount);
    Navigator.of(context).pop(); // Close the modal
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _amountController,
            decoration: const InputDecoration(labelText: 'Amount'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitData,
            child: const Text('Add Transaction'),
          ),
        ],
      ),
    );
  }
}
