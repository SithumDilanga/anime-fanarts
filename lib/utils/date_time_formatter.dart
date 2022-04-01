import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DateTimeFormatter {

  // convert MongoDB createdAt into Datetime
  getFormattedDateFromFormattedString({required value, required String currentFormat, required String desiredFormat, isUtc = false}) {

    DateTime? dateTime = DateTime.now();
    String? formattedDate;

    if (value != null || value.isNotEmpty) {
      try {
        
        //server time(UTC)
        dateTime = DateFormat(currentFormat).parse(value, isUtc).toLocal();

        // -------- convert UTC time to device time ----------

        //get current system local time
        DateTime localDatetime = DateTime.now();

        //get time diff
        var timezoneOffset = localDatetime.timeZoneOffset;
        var timeDiff = new Duration(hours: timezoneOffset.inHours, minutes: timezoneOffset.inMinutes % 60);

        //adjust the time diff
        var newLocalTime = dateTime.add(timeDiff);

        formattedDate = DateFormat(desiredFormat).format(newLocalTime);

        // -------- End convert UTC time to device time ----------

        // formattedDate = DateFormat(desiredFormat).format(dateTime);

      } catch (e) {
        Fluttertoast.showToast(
          msg: 'Error Occured!',
          toastLength: Toast.LENGTH_LONG,
        );
      }
    }
    return formattedDate;
  }

}