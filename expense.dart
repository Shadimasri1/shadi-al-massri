import 'package:flutter/material.dart';

class ExpensePage extends StatelessWidget {
  final double totalPayment;

  ExpensePage({required this.totalPayment});

  @override
  Widget build(BuildContext context) {
    const double maxBudget = 200.0;
    final double remainingBudget = maxBudget - totalPayment;

    return Scaffold(
      appBar: AppBar(title: const Text('Expense Summary')),
      body: Container(
        color: Colors.lightBlue[100], // Baby blue background
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Monthly Expense Summary',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Max Budget: \$${maxBudget.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                'Total Payment: \$${totalPayment.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, color: Colors.red),
              ),
              const SizedBox(height: 10),
              Text(
                'Remaining Budget: \$${remainingBudget.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  color: remainingBudget < 0 ? Colors.red : Colors.green,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
