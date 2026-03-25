import 'package:cloud_firestore/cloud_firestore.dart';

class Calculation {
  final String? firestoreId;
  final String expression;
  final String result;
  final DateTime timestamp;

  const Calculation({
    this.firestoreId,
    required this.expression,
    required this.result,
    required this.timestamp,
  });

  String get historyLine => '$expression = $result';

  String get formattedTime {
    final year = timestamp.year.toString().padLeft(4, '0');
    final month = timestamp.month.toString().padLeft(2, '0');
    final day = timestamp.day.toString().padLeft(2, '0');
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');

    return '$year-$month-$day $hour:$minute';
  }

  Map<String, dynamic> toFirestore() {
    return {
      'expression': expression,
      'result': result,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory Calculation.fromFirestore(
    Map<String, dynamic> map, {
    String? firestoreId,
  }) {
    final rawTimestamp = map['timestamp'];

    DateTime parsedTimestamp;
    if (rawTimestamp is Timestamp) {
      parsedTimestamp = rawTimestamp.toDate();
    } else if (rawTimestamp is String) {
      parsedTimestamp = DateTime.parse(rawTimestamp);
    } else {
      parsedTimestamp = DateTime.now();
    }

    return Calculation(
      firestoreId: firestoreId,
      expression: map['expression'] as String? ?? '',
      result: map['result'] as String? ?? '',
      timestamp: parsedTimestamp,
    );
  }
}
