import 'services/weather_service.dart';

void main() async {
  final service = WeatherService();

  print('=== ทดสอบกรณีที่ 1: สำเร็จ (Status 200 - Bangkok) ===');
  try {
    final weather = await service.fetchWeather('Bangkok');
    print('✅ สำเร็จ!');
    print('เมือง: ${weather.cityName}');
    print('อุณหภูมิ: ${weather.temperature} °C');
    print('สภาพอากาศ: ${weather.description}');
    print('รู้สึกเหมือน: ${weather.feelsLike} °C');
  } catch (e) {
    print('❌ เกิดข้อผิดพลาด: $e');
  }

  print('\n=== ทดสอบกรณีที่ 2: ไม่พบเมือง (Status 404 - InvalidCityXYZ) ===');
  try {
    await service.fetchWeather('InvalidCityXYZ999');
    print('✅ สำเร็จ');
  } catch (e) {
    print('✅ ดักจับ Error ได้ถูกต้อง: $e');
  }
}
