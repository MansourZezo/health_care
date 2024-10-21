part of 'splash_cubit.dart';

abstract class SplashState extends Equatable {
  @override
  List<Object> get props => [];
}

class SplashInitial extends SplashState {}

class SplashPermissionsGranted extends SplashState {}

class SplashPermissionsFailed extends SplashState {
  final String errorMessage;

  SplashPermissionsFailed(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class SplashFirstTimeUser extends SplashState {}

class SplashReturningUser extends SplashState {}
