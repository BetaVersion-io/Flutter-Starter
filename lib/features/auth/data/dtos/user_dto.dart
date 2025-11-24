import 'package:betaversion/features/auth/domain/models/user.dart';

class UserDto {
  final String id;
  final String email;
  final String? name;
  final String? phoneNumber;
  final String? profileImageUrl;
  final String? createdAt;
  final String? updatedAt;

  UserDto({
    required this.id,
    required this.email,
    this.name,
    this.phoneNumber,
    this.profileImageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString(),
      phoneNumber: json['phone_number']?.toString(),
      profileImageUrl: json['profile_image_url']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      if (name != null) 'name': name,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (profileImageUrl != null) 'profile_image_url': profileImageUrl,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    };
  }

  User toDomain() {
    return User(
      id: id,
      email: email,
      name: name,
      phoneNumber: phoneNumber,
      profileImageUrl: profileImageUrl,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) : null,
    );
  }
}
