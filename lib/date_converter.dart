import 'package:intl/intl.dart';

String dateConverter(String dateString) {
  final inputFormat = DateFormat('yyyy-MM-ddTHH:mm:ssZ');
  final outputFormat = DateFormat.yMMMMd(); // Customize the format as needed
  final DateTime dateTime = inputFormat.parse(dateString);
  return outputFormat.format(dateTime);
}
