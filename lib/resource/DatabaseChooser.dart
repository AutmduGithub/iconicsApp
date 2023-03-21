// ignore_for_file: file_names

class DatabaseChooser {
  static String chooseDatabase(String clubname) {
    String dbname = "";
    if (clubname == 'adasclub') {
      dbname = "adas";
    } else if (clubname == "aryabhatta") {
      dbname = "aryabhatta";
    } else if (clubname == "iyalisainadagam") {
      dbname = "iyalisai";
    } else if (clubname == "outreach") {
      dbname = "outreach";
    } else {
      dbname = "iconics";
    }
    return dbname;
  }
}
