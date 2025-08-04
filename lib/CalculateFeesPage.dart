import 'package:flutter/material.dart';
import 'package:mobile/providers/fees_provider.dart';


class CalculateFeesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<FeesProvider>(
      builder: (context, provider, child) {
        if (!provider.isDropdownDataLoaded) {
          return Scaffold(
            appBar: AppBar(title: Text('Calculate Fees'), backgroundColor: Colors.teal),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text('Calculate Fees'), backgroundColor: Colors.teal),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Student ID input
                    TextField(
                      controller: provider.studentIdController,
                      decoration: InputDecoration(
                        labelText: 'Student ID',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: provider.onStudentIdChanged,
                    ),
                    SizedBox(height: 16),

                    if (provider.studentName.isNotEmpty && provider.studentClass.isNotEmpty) ...[
                      Text('Student Name: ${provider.studentName}'),
                      Text('Class: ${provider.studentClass}'),
                      SizedBox(height: 16),
                    ],

                    // Fee Type dropdown
                    DropdownButtonFormField<String>(
                      value: provider.selectedFeeType,
                      onChanged: provider.setSelectedFeeType,
                      hint: Text('Select Fee Type'),
                      items: provider.feeTypes
                          .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                          .toList(),
                      decoration: InputDecoration(
                        labelText: 'Fee Type',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Month dropdown
                    DropdownButtonFormField<String>(
                      value: provider.selectedMonth,
                      onChanged: provider.setSelectedMonth,
                      hint: Text('Select Month'),
                      items: provider.months
                          .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                          .toList(),
                      decoration: InputDecoration(
                        labelText: 'Month',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Year dropdown
                    DropdownButtonFormField<String>(
                      value: provider.selectedYear,
                      onChanged: provider.setSelectedYear,
                      hint: Text('Select Year'),
                      items: provider.years
                          .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                          .toList(),
                      decoration: InputDecoration(
                        labelText: 'Year',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),

                    Text('Payable Amount: \$${provider.fixedAmount.toStringAsFixed(2)}'),
                    SizedBox(height: 16),

                    // Fee amount input
                    TextField(
                      controller: provider.feeAmountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Fee Amount',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),

                    ElevatedButton(
                      onPressed: provider.calculateFees,
                      child: Text('Calculate Fees'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.teal,
                      ),
                    ),
                    SizedBox(height: 16),

                    if (provider.errorMessage.isNotEmpty)
                      Text(provider.errorMessage, style: TextStyle(color: Colors.red)),

                    if (provider.totalFee > 0)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Fee: \$${provider.totalFee.toStringAsFixed(2)}'),
                          Text('Amount Paid: \$${provider.amountPaid.toStringAsFixed(2)}'),
                          Text(
                            'Due Amount: \$${provider.dueAmount.toStringAsFixed(2)}',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
