// ignore_for_file: file_names

class ClubImageChooser {
  static String path = "";
  static String findClub(String string) {
    if (string == "adasclub") {
      path = "https://cseassociation.autmdu.in/res/logos/adas.png";
    } else if (string == "aryabhatta") {
      path = "https://cseassociation.autmdu.in/res/logos/aryabatta.png";
    } else if (string == "iyalisainadagam") {
      path = "https://cseassociation.autmdu.in/res/logos/iyalisai.png";
    } else if (string == "outreach") {
      path = "https://cseassociation.autmdu.in/res/logos/outreach.png";
    } else {
      path = "https://cseassociation.autmdu.in/res/logos/iconics.png";
    }
    return path;
  }
}
