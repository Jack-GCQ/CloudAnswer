class TimeUtils {
  static String millisecond2DateTime(timestamp) {
    if (timestamp.toString() == "null") {
      return "null";
    }
    var timeDate = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp)).toLocal().toString();
    if (timeDate.contains(".")) {
      return timeDate.split(".")[0];
    } else {
      return timeDate;
    }
  }
}
