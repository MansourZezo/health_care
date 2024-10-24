class SignUpModel {
  String? email;
  String? phoneNumber;
  String password;
  String name;
  String? profileImage;
  String? address;
  String? dateOfBirth;
  String? role;
  String? identityProof;
  String? drivingLicense;
  String? medicalCertificate;
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

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'email': email ?? '',
      'phoneNumber': phoneNumber ?? '',
      'password': password,
      'name': name,
      'role': role ?? '',
      'profile': {
        'address': address ?? '',
        'dateOfBirth': dateOfBirth ?? '',
        'profilePicture': profileImage ?? ''
      },
      'identityProof': identityProof ?? '',
      'drivingLicense': drivingLicense ?? '',
      'medicalCertificate': medicalCertificate ?? '',
    };

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

  Map<String, dynamic> toJson() {
    final healthData = <String, dynamic>{};

    if (generalHealthCondition != null) {
      healthData['generalHealthCondition'] = generalHealthCondition;
    }
    if (weight != null) {
      healthData['weight'] = weight;
    }
    if (bloodPressure != null) {
      healthData['bloodPressure'] = bloodPressure;
    }

    return healthData;
  }
}
