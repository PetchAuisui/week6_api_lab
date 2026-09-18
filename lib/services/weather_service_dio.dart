import 'package:dio/dio.dart';
import '../models/weather.dart';

Future<Weather> fetchWeatherWithDio(String city) async {
  final dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  try {
    // dio แปลง JSON response.data ให้เป็น Map ให้อัตโนมัติ ไม่ต้องเรียก jsonDecode เอง
    final response = await dio.get(
      'https://api.openweathermap.org/data/2.5/weather',
      queryParameters: {
        'q': city,
        'appid': '62c3b8b78f4de972a3008ae79653d8af',
        'units': 'metric',
        'lang': 'th',
      },
    );
    return Weather.fromJson(response.data as Map<String, dynamic>);
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
    } else if (e.type == DioExceptionType.badResponse) {
      // เซิร์ฟเวอร์ตอบกลับมาแล้วแต่ status code ผิดพลาด (เช่น 404, 500)
      if (e.response?.statusCode == 404) {
        throw Exception('ไม่พบข้อมูลเมือง "$city" กรุณาตรวจสอบชื่อเมือง');
      }
      throw Exception('เซิร์ฟเวอร์ตอบกลับผิดพลาด (${e.response?.statusCode})');
    } else if (e.type == DioExceptionType.receiveTimeout) {
      // การรับข้อมูลจากเซิร์ฟเวอร์เกินเวลาที่กำหนดไว้
      throw Exception('การรับส่งข้อมูลจากเซิร์ฟเวอร์หมดเวลา กรุณาลองใหม่อีกครั้ง');
    } else if (e.type == DioExceptionType.connectionError) {
      // ไม่สามารถเชื่อมต่อเน็ตเวิร์กได้ เช่น ไม่ได้ต่ออินเทอร์เน็ต หรือ DNS lookup ล้มเหลว
      throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบสัญญาณเน็ต');
    }
    throw Exception('เกิดข้อผิดพลาด: ${e.message}');
  }
}
