import 'package:flutter/material.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  _ManageUsersScreenState createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  String? selectedUser; // المستخدم المختار

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المستخدمين'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: Column(
                children: [
                  // قائمة التصنيفات: مستفيدين، مساعدين، متطوعين
                  Expanded(flex: 2, child: _buildUserCategories(context)),
                  const SizedBox(height: 20),
                  // البطاقة أسفل القائمة
                  _buildUserCard(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCategories(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            labelColor: Colors.blueAccent,
            indicatorColor: Colors.blueAccent,
            tabs: const [
              Tab(text: 'المستفيدين'),
              Tab(text: 'المساعدين'),
              Tab(text: 'المتطوعين'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildUserList(context, 'Beneficiaries'),
                _buildUserList(context, 'Assistants'),
                _buildUserList(context, 'Volunteers'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(BuildContext context, String userType) {
    return ListView.builder(
      itemCount: 10, // استبدل بعدد المستخدمين الفعلي لكل فئة
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text('$userType $index'),
            subtitle: Text('تفاصيل $userType'),
            onTap: () {
              setState(() {
                selectedUser = '$userType $index'; // تعيين المستخدم المختار
              });
            },
          ),
        );
      },
    );
  }

  // بطاقة عرض معلومات المستخدم
  Widget _buildUserCard(BuildContext context) {
    if (selectedUser == null) {
      return const SizedBox(); // عرض مساحة فارغة إذا لم يتم اختيار مستخدم
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تفاصيل $selectedUser',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('الحالة الصحية: الحالة جيدة'),
            const SizedBox(height: 10),
            Text('الأنشطة التي قام بها: المشي اليومي، قراءة كتاب'),
            const SizedBox(height: 10),
            Text('التقييم: 5 نجوم'),
            const SizedBox(height: 10),
            // الأزرار لتعديل البيانات على شكل أيقونات
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildIconButton(context,
                    icon: Icons.health_and_safety,
                    label: 'البيانات الصحية',
                    onTap: () {}),
                _buildIconButton(
                  context,
                  icon: Icons.person,
                  label: 'البيانات الشخصية',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // زر الإجراء لتعديل البيانات على شكل أيقونة مع نص
  Widget _buildIconButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        IconButton(
          onPressed: onTap,
          icon: Icon(icon, size: 30, color: Colors.blueAccent),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.blueAccent),
        ),
      ],
    );
  }
}
