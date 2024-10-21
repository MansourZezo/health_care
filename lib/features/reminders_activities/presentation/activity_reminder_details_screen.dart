import 'package:flutter/material.dart';

class ActivityReminderDetailsScreen extends StatelessWidget {
  final bool isActivity;
  final Map<String, String> details;

  const ActivityReminderDetailsScreen({
    super.key,
    required this.isActivity,
  }) : details = const {
    "name": "المشي الصباحي",
    "type": "رياضة",
    "description": "قم بالمشي لمدة 30 دقيقة في الحديقة للاستمتاع بالهواء النقي وتحسين اللياقة البدنية.",
    "date": "2024-10-14",
    "status": "مكتمل",
    "duration": "30 دقيقة",
  };

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
                titlePadding: const EdgeInsets.only(bottom: 10),
                title: const Text('تفاصيل النشاط'),
                background: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _WavePainter(),
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
                          child: Icon(
                            isActivity ? Icons.event : Icons.alarm,
                            size: 50,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // منطق التعديل
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context);
                  },
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const SizedBox(height: 20),
                    _buildDetailRow(context, 'الاسم', details['name'] ?? 'غير محدد'),
                    _buildDetailRow(context, 'النوع', details['type'] ?? 'غير محدد'),
                    _buildDetailRow(context, 'الوصف', details['description'] ?? 'لا يوجد'),
                    _buildDetailRow(context, 'التاريخ', details['date'] ?? 'غير محدد'),
                    if (isActivity) _buildDetailRow(context, 'الحالة', details['status'] ?? 'غير محددة'),
                    _buildDetailRow(context, 'المدة', details['duration'] ?? 'غير محددة'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تأكيد الحذف'),
          content: const Text('هل أنت متأكد أنك تريد حذف هذا النشاط أو التذكير؟'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                // منطق الحذف
                Navigator.of(context).pop();
              },
              child: const Text('حذف'),
            ),
          ],
        );
      },
    );
  }
}

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
        size.width * 0.5, size.height * 0.6,
      )
      ..quadraticBezierTo(
        size.width * 0.75, size.height * 0.45,
        size.width, size.height * 0.6,
      )
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
