// ignore_for_file: file_names

class SocketChooser {
  static String selectSocket(String clubname) {
    String socket = '';
    if (clubname == "adasclub") {
      socket = "AdasserverMsg";
    } else if (clubname == "aryabhatta") {
      socket = "AryaserverMsg";
    } else if (clubname == "iyalisainadagam") {
      socket = "IyalisaiserverMsg";
    } else if (clubname == "outreach") {
      socket = "OutreachserverMsg";
    } else if (clubname == 'Iconics') {
      socket = "IconicsserverMsg";
    } else {
      socket = "discussserverMsg";
    }
    return socket;
  }
}
