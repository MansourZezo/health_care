import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // تبويبتين: تقارير الأنشطة وتقارير الصحة
      child: Scaffold(
        appBar: AppBar(
          title: const Text('التقارير'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'تقارير الأنشطة'),
              Tab(text: 'تقارير الصحة'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildActivityReports(),
            _buildHealthReports(),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityReports() {
    // بناء محتوى تبويب تقارير الأنشطة
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5, // عدد التقارير (مثال)
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'النشاط ${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'المتطوع: أحمد محمد\nالتقييم: 4.5/5\nملاحظات: أداء جيد وتعاون ممتاز',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      // الانتقال إلى صفحة التفاصيل
                    },
                    child: const Text('عرض التفاصيل'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHealthReports() {
    // بناء محتوى تبويب تقارير الصحة
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5, // عدد التقارير (مثال)
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'التقرير الصحي ${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'المستفيد: محمد علي\nضغط الدم: 120/80\nمستوى السكر: 90 mg/dL\nالوزن: 75 kg',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      // الانتقال إلى صفحة التفاصيل
                    },
                    child: const Text('عرض التفاصيل'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
