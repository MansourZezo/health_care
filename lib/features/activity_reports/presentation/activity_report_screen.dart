import 'package:flutter/material.dart';

class ActivityReportScreen extends StatelessWidget {
  const ActivityReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 250.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                titlePadding: const EdgeInsets.only(bottom: 20),
                title: const Text('تقرير النشاط'),
                background: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _WavePainter(), // تغيير التموجات إلى الأيقونة
                      ),
                    ),
                    Positioned(
                      top: 125, // تعديل الارتفاع لجعل الأيقونة بين الموجة والبيانات
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: 75,
                          height: 75,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.description, // أيقونة جديدة حسب اختيارك
                            size: 50,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    const SizedBox(height: 20),

                    // اسم النشاط ونوعه في منتصف الصفحة
                    _buildCenteredLabels('اسم النشاط', 'نوع النشاط'),

                    const SizedBox(height: 20),

                    // وصف النشاط
                    _buildSectionTitle('وصف النشاط'),
                    _buildTextField(
                      labelText: 'وصف النشاط',
                      hintText: 'مرافقة المستفيد إلى موعد طبي',
                      multiLine: true,
                      maxLines: 5, // حجم الحقل المناسب لوصف متعدد الأسطر
                    ),

                    const SizedBox(height: 20),

                    // المدة
                    _buildSectionTitle('المدة'),
                    _buildTextField(
                      labelText: 'المدة (بالدقائق)',
                      hintText: '45 دقيقة',
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 20),

                    // تقييم النشاط
                    _buildSectionTitle('تقييم النشاط'),
                    _buildCenteredRatingRow(5),

                    const SizedBox(height: 20),

                    // الملاحظات
                    _buildSectionTitle('الملاحظات'),
                    _buildTextField(
                      labelText: 'الملاحظات',
                      hintText: 'ضغط الدم كان مستقرًا، ولا أعراض غير طبيعية.',
                      multiLine: true,
                      maxLines: 5, // حجم الحقل المناسب للملاحظات
                    ),

                    const SizedBox(height: 40),

                    // زر إرسال التقرير
                    ElevatedButton(
                      onPressed: () {
                        // قم بإضافة الكود الخاص بحفظ التقرير هنا
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'إرسال التقرير',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black, // اللون الأسود لجميع الخطوط
        ),
      ),
    );
  }

  // إضافة الحقول في منتصف الصفحة مع النصوص
  Widget _buildCenteredLabels(String title, String subtitle) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  // حقل النص المتعدد
  Widget _buildTextField({
    required String labelText,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool multiLine = false,
    int maxLines = 1, // الافتراضي هو سطر واحد، ولكن يمكنك تغييره إلى 5 أو أكثر حسب الحاجة
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextFormField(
        maxLines: multiLine ? maxLines : 1, // التحكم بعدد الأسطر
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          labelStyle: const TextStyle(color: Colors.black),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
          ),
        ),
      ),
    );
  }

  // تعديل النجوم لتكون في المنتصف
  Widget _buildCenteredRatingRow(int rating) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          5,
              (index) => Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: index < rating ? Colors.amber : Colors.grey[400],
            size: 30,
          ),
        ),
      ),
    );
  }
}

// رسم التموجات
class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.6)
      ..quadraticBezierTo(
          size.width * 0.25, size.height * 0.75,
          size.width * 0.5, size.height * 0.6)
      ..quadraticBezierTo(
          size.width * 0.75, size.height * 0.45,
          size.width, size.height * 0.6)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
