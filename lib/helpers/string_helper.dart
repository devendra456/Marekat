class StringHelper {
  bool stringContains(string, part) {
    return string.toLowerCase().contains(part.toLowerCase());
  }

  static String getRealPrice(String price) {
    if (price.length > 6) return price.substring(0, price.lastIndexOf(".") + 3);
    return price;
  }
}
