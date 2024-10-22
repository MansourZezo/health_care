import 'package:flutter/material.dart';

class ActivityManagementScreen extends StatefulWidget {
  const ActivityManagementScreen({super.key});

  @override
  ActivityManagementScreenState createState() => ActivityManagementScreenState();
}

class ActivityManagementScreenState extends State<ActivityManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedRole = 'Beneficiary'; // المستفيد أو المتطوع
  String selectedUser = ''; // المستخدم المختار
  List<String> beneficiaries = ['مستفيد 1', 'مستفيد 2', 'مستفيد 3'];
  List<String> volunteers = ['متطوع 1', 'متطوع 2', 'متطوع 3'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    selectedUser = beneficiaries[0]; // المستخدم الافتراضي
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الأنشطة'),
        backgroundColor: Colors.blueAccent,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'مستفيدين'),
            Tab(text: 'متطوعين'),
          ],
          onTap: (index) {
            setState(() {
              selectedRole = index == 0 ? 'Beneficiary' : 'Volunteer';
              selectedUser = index == 0
                  ? beneficiaries.isNotEmpty ? beneficiaries[0] : ''
                  : volunteers.isNotEmpty ? volunteers[0] : '';
            });
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _showUserSelectionModal, // عرض قائمة المستخدمين
            child: Text('اختر ${selectedRole == 'Beneficiary' ? 'مستفيد' : 'متطوع'}'),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (selectedUser.isNotEmpty)
                    Text(
                      'تفاصيل $selectedUser',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  const SizedBox(height: 20),
                  selectedRole == 'Beneficiary'
                      ? _buildBeneficiaryActivities()
                      : _buildVolunteerActivities(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // عرض Bottom Sheet لاختيار المستخدم
  void _showUserSelectionModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'اختر ${selectedRole == 'Beneficiary' ? 'مستفيد' : 'متطوع'}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: selectedRole == 'Beneficiary'
                      ? beneficiaries.length
                      : volunteers.length,
                  itemBuilder: (context, index) {
                    String user = selectedRole == 'Beneficiary'
                        ? beneficiaries[index]
                        : volunteers[index];
                    return ListTile(
                      title: Text(user),
                      onTap: () {
                        setState(() {
                          selectedUser = user;
                        });
                        Navigator.pop(context); // إغلاق الـ Bottom Sheet بعد الاختيار
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // واجهة عرض الأنشطة للمستفيدين (تعديل وتخصيص الأنشطة)
  Widget _buildBeneficiaryActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildActivityDetails(),
        const SizedBox(height: 20),
        _buildEditActivityForm(), // تعديل الأنشطة
      ],
    );
  }

  // واجهة عرض الأنشطة للمتطوعين (عرض التفاصيل فقط)
  Widget _buildVolunteerActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildActivityDetails(), // عرض الأنشطة التي قام بها المتطوع
        const SizedBox(height: 20),
        _buildVolunteerReportSection(), // عرض تقرير المتطوع
      ],
    );
  }

  // عرض تفاصيل الأنشطة (مستفيدين أو متطوعين)
  Widget _buildActivityDetails() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الأنشطة المنجزة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildActivityTile('المشي اليومي', 'مكتمل', 5),
            _buildActivityTile('زيارة الطبيب', 'غير مكتمل', 3),
          ],
        ),
      ),
    );
  }

  // عنصر صغير لعرض نشاط
  Widget _buildActivityTile(String activity, String status, int rating) {
    return ListTile(
      title: Text(activity),
      subtitle: Text('الحالة: $status'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
            rating, (index) => const Icon(Icons.star, color: Colors.amber)),
      ),
    );
  }

  // نموذج تعديل الأنشطة للمستفيدين
  Widget _buildEditActivityForm() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تعديل الأنشطة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildTextField('اسم النشاط', 'المشي اليومي'),
            const SizedBox(height: 10),
            _buildTextField('الحالة', 'مكتمل'),
            const SizedBox(height: 10),
            _buildTextField('التقييم', '5'),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // تنفيذ الحفظ
              },
              icon: const Icon(Icons.save),
              label: const Text('حفظ التعديلات'),
            ),
          ],
        ),
      ),
    );
  }


  // حقل إدخال نصي لتعديل الأنشطة
  Widget _buildTextField(String label, String initialValue) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      controller: TextEditingController(text: initialValue),
    );
  }

  // عرض تقرير المتطوع
  Widget _buildVolunteerReportSection() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تقرير المتطوع',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildTextDisplay('التقييم العام', '4'),
            const SizedBox(height: 10),
            _buildTextDisplay('ملاحظات', 'قام بإنهاء النشاط بنجاح'),
          ],
        ),
      ),
    );
  }

  // عرض النصوص فقط في تقرير المتطوع
  Widget _buildTextDisplay(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    );
  }
}
