String getBackgroundImage(String month) {
  // Map months to their respective background images based on the grouping
  Map<String, String> monthBackgroundMap = {
    'March': 'assets/summer.jpg',
    'April': 'assets/summer.jpg',
    'May': 'assets/summer.jpg',
    'June': 'assets/rainy.jpg',
    'July': 'assets/rainy.jpg',
    'August': 'assets/rainy.jpg',
    'September': 'assets/rainy.jpg',
    'October': 'assets/rainy.jpg',
    'November': 'assets/winter.jpg',
    'December': 'assets/winter.jpg',
    'January': 'assets/winter.jpg',
    'February': 'assets/winter.jpg',
  };

  // Get the background image based on the month
  return monthBackgroundMap[month] ??
      'assets/background.jpg'; // Default background image
}
