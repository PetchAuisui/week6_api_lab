class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final double feelsLike;

  const Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.feelsLike,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    // ดึงค่าจาก object ย่อย 'main' (cast เป็น Map<String, dynamic>)
    final main = json['main'] as Map<String, dynamic>;
    final temperature = (main['temp'] as num).toDouble();
    final feelsLike = (main['feels_like'] as num).toDouble();

    // cast json['weather'] เป็น List<dynamic> แล้วดึงตัวแรกออกมาเป็น Map<String, dynamic>
    final weatherList = json['weather'] as List<dynamic>;
    final weatherFirst = weatherList[0] as Map<String, dynamic>;
    final description = weatherFirst['description'] as String;

    // ดึง cityName จาก key 'name' ที่ระดับบนสุด
    final cityName = json['name'] as String;

    return Weather(
      cityName: cityName,
      temperature: temperature,
      description: description,
      feelsLike: feelsLike,
    );
  }
}
