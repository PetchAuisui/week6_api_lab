import 'services/weather_service_dio.dart';

void main() async {
  print('=== ทดสอบ fetchWeatherWithDio("Bangkok") ===');
  try {
    final weather = await fetchWeatherWithDio('Bangkok');
    print('cityName: ${weather.cityName}');
    print('temperature: ${weather.temperature}');
    print('description: ${weather.description}');
    print('feelsLike: ${weather.feelsLike}');
  } catch (e) {
    print('Error: $e');
  }

  print('\n=== ทดสอบ Dio กรณี 404 (เมืองไม่มีจริง) ===');
  try {
    await fetchWeatherWithDio('InvalidXYZ999');
  } catch (e) {
    print('ดักจับ Error ได้: $e');
  }
}
