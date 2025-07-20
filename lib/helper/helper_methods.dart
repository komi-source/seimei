import 'package:cloud_firestore/cloud_firestore.dart';

String FormatDate(Timestamp timeStamp) {
  DateTime dateTime = timeStamp.toDate();

  String year = dateTime.year.toString();
  String moth = dateTime.month.toString();
  String day = dateTime.day.toString();
  String formattedData = ' $year/$moth/$day';

  return formattedData;
}
