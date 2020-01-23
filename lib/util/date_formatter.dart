import 'package:intl/intl.dart';

String dateFormatted(){
  return DateFormat.yMEd().add_jms().format(DateTime.now());
}