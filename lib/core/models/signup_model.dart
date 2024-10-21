class SignUpModel {
  String? email;
  String? phoneNumber;
  String password;
  String name;
  String? profileImage;
  String? address;
  String? dateOfBirth;
  String? role;

  // المستندات الخاصة بالمتطوع
  String? identityProof;
  String? drivingLicense;
  String? medicalCertificate;

  // المعلومات الصحية للمستفيد
  HealthInfo? healthInfo;

  SignUpModel({
    this.email,
    this.phoneNumber,
    required this.password,
    required this.name,
    this.profileImage,
    this.address,
    this.dateOfBirth,
    this.role,
    this.identityProof,
    this.drivingLicense,
    this.medicalCertificate,
    this.healthInfo,
  });

  // لتحويل النموذج إلى JSON عند الإرسال إلى السيرفر
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
      'name': name,
      'role': role,
      'profile': {  // هنا يتم إضافة الحقول ضمن كائن profile
        'address': address,
        'dateOfBirth': dateOfBirth,
        'profilePicture': profileImage
      },
      'identityProof': identityProof,
      'drivingLicense': drivingLicense,
      'medicalCertificate': medicalCertificate,
    };

    // إضافة المعلومات الصحية إذا كان المستخدم مستفيدًا
    if (role == 'Beneficiary' && healthInfo != null) {
      data['healthInfo'] = healthInfo!.toJson();
    }

    return data;
  }
}


class HealthInfo {
  String? generalHealthCondition;
  int? weight;
  String? bloodPressure;

  HealthInfo({
    this.generalHealthCondition,
    this.weight,
    this.bloodPressure,
  });

  // لتحويل المعلومات الصحية إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'generalHealthCondition': generalHealthCondition,
      'weight': weight,
      'bloodPressure': bloodPressure,
    };
  }
}
