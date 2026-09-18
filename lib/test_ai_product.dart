import 'services/ai_product_service.dart';

void main() async {
  print('=== กำลังดึงข้อมูลสินค้าจาก Fake Store API... ===');
  try {
    final products = await fetchAiProducts();
    print('✅ ดึงข้อมูลสำเร็จ! พบสินค้าทั้งหมด ${products.length} รายการ:\n');
    for (final p in products.take(5)) {
      print('[ID: ${p.id}] ${p.title}');
      print('  ราคา: \$${p.price} | หมวดหมู่: ${p.category}');
      print('  รูปภาพ: ${p.image}');
      print('---');
    }
    print('...และรายการอื่นๆ รวมทั้งหมด ${products.length} รายการ');
  } catch (e) {
    print('❌ เกิดข้อผิดพลาด: $e');
  }
}
