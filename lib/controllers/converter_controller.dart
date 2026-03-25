class ConverterController {
  static const double _kmToMileFactor = 0.621371;

  double? convert(String input) {
    final double? km = double.tryParse(input);
    if (km == null) return null;
    return km * _kmToMileFactor;
  }
}
