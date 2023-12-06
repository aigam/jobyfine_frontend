part of 'auth_bloc.dart';

class AuthEvent {}

class SendProfileEvent extends AuthEvent {
  UserRegModel userRegModel;
  String token;
  final RegisterConfirmationMethod registerConfirmationMethod;

  SendProfileEvent(
    this.userRegModel,
    this.token,
    this.registerConfirmationMethod,
  );
}

class ConfirmCodeResetEvent extends AuthEvent {
  String phone;
  String code;

  ConfirmCodeResetEvent(this.phone, this.code);
}

class ConfirmCodeEvent extends AuthEvent {
  String phone;
  String code;
  int? refCode;
  UserRegModel userRegModel;

  RegisterConfirmationMethod registerConfirmationMethod;
  String sendCodeServer;
  String confirmationCodeUser;

  ConfirmCodeEvent(
    this.phone,
    this.code,
    this.userRegModel,
    this.registerConfirmationMethod,
    this.sendCodeServer,
    this.confirmationCodeUser,
  );
}

class EditPasswordEvent extends AuthEvent {
  String password;
  String token;
  String fcmToken;

  EditPasswordEvent(this.password, this.token, this.fcmToken);
}

class RestoreCodeEvent extends AuthEvent {
  String login;

  RestoreCodeEvent(this.login);
}

class RestoreCodeCheckEvent extends AuthEvent {
  String phone;
  String code;
  String updatePassword;

  RestoreCodeCheckEvent(this.phone, this.code, this.updatePassword);
}

class GetCategoriesEvent extends AuthEvent {}

class SignInEvent extends AuthEvent {
  String phone;
  String password;
  String token;
  SignInEvent(this.phone, this.password, this.token);
}

class CheckUserExistEvent extends AuthEvent {
  String phone;
  String email;

  CheckUserExistEvent(this.phone, this.email);
}
