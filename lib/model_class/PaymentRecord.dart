/// Represents a single payment record for a student.
class PaymentRecord {
  final String studentId;   // Unique identifier for the student
  final String feeType;     // Type of fee (e.g., Tuition, Library, Exam)
  final String month;       // Month the fee applies to (e.g., "January")
  final double amountPaid;  // Actual amount paid by the student
  final double totalFee;    // Total fee due for the type/month

  PaymentRecord({
    required this.studentId,
    required this.feeType,
    required this.month,
    required this.amountPaid,
    required this.totalFee,
  });

  /// Factory constructor to create a [PaymentRecord] instance from JSON.
  factory PaymentRecord.fromJson(Map<String, dynamic> json) {
    return PaymentRecord(
      studentId: json['studentId'] ?? '',
      feeType: json['feeType'] ?? '',
      month: json['month'] ?? '',
      amountPaid: (json['amountPaid'] ?? 0).toDouble(),
      totalFee: (json['totalFee'] ?? 0).toDouble(),
    );
  }

  /// Converts the object back into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'feeType': feeType,
      'month': month,
      'amountPaid': amountPaid,
      'totalFee': totalFee,
    };
  }

  /// Optional: Calculate balance due for that fee
  double get balanceDue => totalFee - amountPaid;

  /// Optional: Check if the payment is complete
  bool get isFullyPaid => amountPaid >= totalFee;
}
