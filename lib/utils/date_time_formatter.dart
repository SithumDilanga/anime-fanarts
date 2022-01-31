import 'package:intl/intl.dart';

class DateTimeFormatter {

  // convert MongoDB createdAt into Datetime
  getFormattedDateFromFormattedString({required value, required String currentFormat, required String desiredFormat, isUtc = false}) {

    DateTime? dateTime = DateTime.now();
    String? formattedDate;

    if (value != null || value.isNotEmpty) {
      try {
        
        dateTime = DateFormat(currentFormat).parse(value, isUtc).toLocal();

        formattedDate = DateFormat(desiredFormat).format(dateTime);

      } catch (e) {
        print("$e");
      }
    }
    return formattedDate;
  }

}