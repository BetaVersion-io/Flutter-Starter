import 'package:equatable/equatable.dart';

class UpdateProfileRequest extends Equatable {
  final String? name;
  final String? phoneNumber;
  final String? profileImageUrl;

  const UpdateProfileRequest({
    this.name,
    this.phoneNumber,
    this.profileImageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (profileImageUrl != null) 'profile_image_url': profileImageUrl,
    };
  }

  @override
  List<Object?> get props => [name, phoneNumber, profileImageUrl];
}
