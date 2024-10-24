import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccessLogin extends AuthState {}

class AuthSuccessSignup extends AuthState {
  final String profileId;

  AuthSuccessSignup({required this.profileId});

  @override
  List<Object> get props => [profileId];
}

// حالة لتمثيل فشل تسجيل الدخول
class AuthFailureLogin extends AuthState {
  final String errorMessage;

  AuthFailureLogin(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

// حالة لتمثيل فشل التسجيل
class AuthFailureSignup extends AuthState {
  final String errorMessage;

  AuthFailureSignup(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

// حالة لتمثيل اختيار نوع المستخدم
class UserTypeSelected extends AuthState {
  final String userType;

  UserTypeSelected(this.userType);

  @override
  List<Object> get props => [userType];
}

// حالة تمثيل نجاح رفع الملف
class AuthSuccessUpload extends AuthState {
  final String fileUrl;

  AuthSuccessUpload(this.fileUrl);

  @override
  List<Object> get props => [fileUrl];
}

// حالة تمثيل فشل رفع الملف
class AuthFailureUpload extends AuthState {
  final String errorMessage;

  AuthFailureUpload(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
