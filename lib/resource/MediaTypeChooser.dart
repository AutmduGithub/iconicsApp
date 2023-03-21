// ignore_for_file: file_names, non_constant_identifier_names

class MediaTypeChooser {
  static String MediaType = "";
  static String ChooseMedia(String url) {
    String urltype = url.substring(url.length - 3).toLowerCase();
    if (urltype == "jpg" || urltype == "png") {
      MediaType = "photo";
    } else {
      MediaType = "video";
    }
    return MediaType;
  }
}
