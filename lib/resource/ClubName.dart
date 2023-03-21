class ClubNameChooser {
  static String path = "";
  static String findClub(String string) {
    if (string == "adasclub") {
      path = "Ada's Club";
    } else if (string == "aryabhatta") {
      path = "Aryabhatta Club";
    } else if (string == "iyalisainadagam") {
      path = "IyalIsaiNadagam";
    } else if (string == "outreach") {
      path = "Outreach Club";
    } else if (string == 'Iconics') {
      path = "Iconics";
    } else {
      path = "Discussion";
    }
    return path;
  }
}
