import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// Model class AiProduct
class AiProduct {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;

  const AiProduct({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
  });

  /// แปลงตัวเลขผ่าน 'num' แล้วเรียก .toDouble() เสมอ
  /// ป้องกัน Runtime Crash: type 'int' is not a subtype of type 'double' เมื่อ API ส่งจำนวนเต็มมา
  factory AiProduct.fromJson(Map<String, dynamic> json) {
    return AiProduct(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
    };
  }
}

/// ฟังก์ชันดึงสินค้าทั้งหมด (GET https://fakestoreapi.com/products)
Future<List<AiProduct>> fetchAiProducts() async {
  final uri = Uri.parse('https://fakestoreapi.com/products');

  try {
    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final dynamic decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is List) {
        return decoded
            .map((item) => AiProduct.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw const FormatException('ข้อมูลที่ส่งกลับมาไม่ใช่ List');
      }
    } else {
      throw HttpException('เซิร์ฟเวอร์ขัดข้อง (รหัสสถานะ: ${response.statusCode})');
    }
  } on TimeoutException {
    throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง (เกิน 10 วินาที)');
  } on http.ClientException {
    throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อของคุณ');
  } on SocketException {
    throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบสัญญาณเน็ต');
  } on FormatException {
    throw Exception('ข้อมูลที่ได้รับจากเซิร์ฟเวอร์ไม่ถูกต้องตามรูปแบบ (JSON Format Error)');
  } on HttpException catch (e) {
    throw Exception(e.message);
  } catch (e) {
    throw Exception('เกิดข้อผิดพลาดที่ไม่คาดคิด กรุณาลองใหม่อีกครั้ง: ${e.toString()}');
  }
}

/// ฟังก์ชันดึงข้อมูลสินค้าชิ้นเดียวตาม ID (GET https://fakestoreapi.com/products/{id})
Future<AiProduct> fetchAiProductById(int id) async {
  final uri = Uri.parse('https://fakestoreapi.com/products/$id');

  try {
    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      if (response.body.trim().isEmpty || response.body.trim() == 'null') {
        throw HttpException('ไม่พบสินค้ารหัส $id ในระบบ');
      }

      final dynamic decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is Map<String, dynamic>) {
        return AiProduct.fromJson(decoded);
      } else {
        throw const FormatException('ข้อมูลสินค้าชิ้นนี้ไม่ใช่โครงสร้าง Map');
      }
    } else if (response.statusCode == 404) {
      throw HttpException('ไม่พบสินค้ารหัส $id ในระบบ (รหัสสถานะ: 404)');
    } else {
      throw HttpException('เซิร์ฟเวอร์ขัดข้อง (รหัสสถานะ: ${response.statusCode})');
    }
  } on TimeoutException {
    throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง (เกิน 10 วินาที)');
  } on http.ClientException {
    throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อของคุณ');
  } on SocketException {
    throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบสัญญาณเน็ต');
  } on FormatException {
    throw Exception('ข้อมูลที่ได้รับจากเซิร์ฟเวอร์ไม่ถูกต้องตามรูปแบบ (JSON Format Error)');
  } on HttpException catch (e) {
    throw Exception(e.message);
  } catch (e) {
    throw Exception('เกิดข้อผิดพลาดในการโหลดสินค้า: ${e.toString()}');
  }
}
