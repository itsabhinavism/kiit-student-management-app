import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FeesScreen extends StatelessWidget {
  final String rollNumber;

  FeesScreen({Key? key, required this.rollNumber}) : super(key: key);

  final List<FeeItem> feeItems = [
    FeeItem(
      title: 'Tuition Fee (Semester 1)',
      amount: 50000,
      status: FeeStatus.paid,
      dueDate: DateTime(2023, 8, 15),
      paymentDate: DateTime(2023, 8, 10),
    ),
    FeeItem(
      title: 'Hostel Fee (Yearly)',
      amount: 30000,
      status: FeeStatus.paid,
      dueDate: DateTime(2023, 9, 30),
      paymentDate: DateTime(2023, 9, 20),
    ),
    FeeItem(
      title: 'Exam Fee (Semester 2)',
      amount: 10000,
      status: FeeStatus.pending,
      dueDate: DateTime(2024, 2, 28),
    ),
    FeeItem(
      title: 'Library Fine',
      amount: 500,
      status: FeeStatus.pending,
      dueDate: DateTime(2024, 1, 15),
    ),
    FeeItem(
      title: 'Development Fee',
      amount: 12000,
      status: FeeStatus.paid,
      dueDate: DateTime(2023, 10, 10),
      paymentDate: DateTime(2023, 10, 5),
    ),
    FeeItem(
      title: 'Convocation Fee',
      amount: 1500,
      status: FeeStatus.pending,
      dueDate: DateTime(2025, 3, 31),
    ),
    FeeItem(
      title: 'ID Card Replacement',
      amount: 300,
      status: FeeStatus.paid,
      dueDate: DateTime(2023, 11, 10),
      paymentDate: DateTime(2023, 11, 8),
    ),
    FeeItem(
      title: 'Backlog Exam Fee',
      amount: 2500,
      status: FeeStatus.pending,
      dueDate: DateTime(2024, 12, 5),
    ),
    FeeItem(
      title: 'Bus Fee (Semester 1)',
      amount: 6000,
      status: FeeStatus.paid,
      dueDate: DateTime(2023, 7, 1),
      paymentDate: DateTime(2023, 6, 25),
    ),
    FeeItem(
      title: 'Late Registration Fine',
      amount: 1000,
      status: FeeStatus.pending,
      dueDate: DateTime(2025, 2, 1),
    ),
  ];

  double get totalPaid => feeItems
      .where((item) => item.status == FeeStatus.paid)
      .fold(0.0, (sum, item) => sum + item.amount);

  double get totalPending => feeItems
      .where((item) => item.status == FeeStatus.pending)
      .fold(0.0, (sum, item) => sum + item.amount);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Fees Information',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.green.shade700,
      ),
      body: Container(
        color: isDarkMode ? Colors.black : Colors.green.shade100,
        child: Column(
          children: [
            _buildSummaryCard(isDarkMode),
            Expanded(
              child: ListView.builder(
                itemCount: feeItems.length,
                itemBuilder: (context, index) {
                  final fee = feeItems[index];
                  return _buildFeeCard(context, fee, isDarkMode);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.green.shade900 : Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem("Total Paid", totalPaid, isDarkMode ? Colors.green[400]! : Colors.green),
          _buildSummaryItem("Total Pending", totalPending, isDarkMode ? Colors.red[400]! : Colors.red),
          _buildSummaryItem("Overall", totalPaid + totalPending, isDarkMode ? Colors.blue[400]! : Colors.blue),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, double amount, Color color) {
    return Column(
      children: [
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildFeeCard(BuildContext context, FeeItem fee, bool isDarkMode) {
    final isOverdue = fee.status == FeeStatus.pending &&
        fee.dueDate != null &&
        fee.dueDate!.isBefore(DateTime.now());

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.green.shade900 : Colors.green.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: Icon(
            fee.status == FeeStatus.paid ? Icons.check_circle : Icons.warning,
            color: fee.status == FeeStatus.paid
                ? isDarkMode ? Colors.green[400] : Colors.green
                : (isOverdue 
                    ? isDarkMode ? Colors.red[400] : Colors.red 
                    : isDarkMode ? Colors.orange[400] : Colors.orange),
            size: 32,
          ),
          title: Text(
            fee.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Amount: ₹${fee.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey[300] : Colors.black87,
                  ),
                ),
                Text(
                  'Due Date: ${DateFormat('dd-MM-yyyy').format(fee.dueDate!)}',
                  style: TextStyle(
                    color: isOverdue 
                        ? isDarkMode ? Colors.red[400] : Colors.red 
                        : isDarkMode ? Colors.grey[300] : Colors.black87,
                    fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (fee.paymentDate != null)
                  Text(
                    'Paid on: ${DateFormat('dd-MM-yyyy').format(fee.paymentDate!)}',
                    style: TextStyle(
                      color: isDarkMode ? Colors.green[400] : Colors.green,
                    ),
                  ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Chip(
                      label: Text(
                        fee.status == FeeStatus.paid
                            ? 'PAID'
                            : (isOverdue ? 'OVERDUE' : 'PENDING'),
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: fee.status == FeeStatus.paid
                          ? isDarkMode ? Colors.green[700] : Colors.green
                          : isOverdue
                          ? isDarkMode ? Colors.red[700] : Colors.red
                          : isDarkMode ? Colors.orange[700] : Colors.orange,
                    ),
                    const Spacer(),
                    if (fee.status == FeeStatus.pending)
                      TextButton.icon(
                        onPressed: () {
                          // Implement pay now action
                        },
                        icon: Icon(Icons.payment, color: isDarkMode ? Colors.blue[400] : Colors.blue),
                        label: Text("Pay Now", style: TextStyle(color: isDarkMode ? Colors.blue[400] : Colors.blue)),
                      )
                    else
                      TextButton.icon(
                        onPressed: () {
                          // Implement receipt action
                        },
                        icon: Icon(Icons.receipt_long, color: isDarkMode ? Colors.green[400] : Colors.green),
                        label: Text("Receipt", style: TextStyle(color: isDarkMode ? Colors.green[400] : Colors.green)),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Enum to represent fee payment status
enum FeeStatus { paid, pending }

// FeeItem model class
class FeeItem {
  final String title;
  final double amount;
  final FeeStatus status;
  final DateTime? dueDate;
  final DateTime? paymentDate;

  FeeItem({
    required this.title,
    required this.amount,
    required this.status,
    this.dueDate,
    this.paymentDate,
  });
}