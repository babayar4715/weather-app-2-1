class Weather {
  Weather({
    this.country,
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
    required this.city,
    required this.temp,
  });
  final int id;
  final String main;
  final String description;
  final String icon;
  final String city;
  final double temp;
  final String? country;
}
