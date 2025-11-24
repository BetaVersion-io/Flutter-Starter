import 'package:equatable/equatable.dart';

class RegisterRequest extends Equatable {
  final String email;
  final String password;
  final String? name;
  final String? phoneNumber;

  const RegisterRequest({
    required this.email,
    required this.password,
    this.name,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      if (name != null) 'name': name,
      if (phoneNumber != null) 'phone_number': phoneNumber,
    };
  }

  @override
  List<Object?> get props => [email, password, name, phoneNumber];
}
