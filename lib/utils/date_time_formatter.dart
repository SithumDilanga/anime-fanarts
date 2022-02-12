import 'package:intl/intl.dart';

class DateTimeFormatter {

  // convert MongoDB createdAt into Datetime
  getFormattedDateFromFormattedString({required value, required String currentFormat, required String desiredFormat, isUtc = false}) {

    DateTime? dateTime = DateTime.now();
    String? formattedDate;

    if (value != null || value.isNotEmpty) {
      try {
        
        //server time(UTC)
        dateTime = DateFormat(currentFormat).parse(value, isUtc).toLocal();

        print('timeZoneName ${dateTime.timeZoneOffset}');

        // -------- convert UTC time to device time ----------

        //get current system local time
        DateTime localDatetime = DateTime.now();

        //get time diff
        var timezoneOffset = localDatetime.timeZoneOffset;
        var timeDiff = new Duration(hours: timezoneOffset.inHours, minutes: timezoneOffset.inMinutes % 60);

        //adjust the time diff
        var newLocalTime = dateTime.add(timeDiff);

        print('new_local_time $newLocalTime');

        formattedDate = DateFormat(desiredFormat).format(newLocalTime);

        // -------- End convert UTC time to device time ----------

        // formattedDate = DateFormat(desiredFormat).format(dateTime);

      } catch (e) {
        print("$e");
      }
    }
    return formattedDate;
  }

}