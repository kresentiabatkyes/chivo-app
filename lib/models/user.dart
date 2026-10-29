class UserProfile {
  final String name;
  final String username;
  final String email;
  final String password;
  final String role;
  final String? phone;
  final String? address; 

  const UserProfile({
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    required this.role,
    this.phone,
    this.address,
  });

  String get greeting => 'Halo, $name!';
  String get phoneDisplay => phone ?? 'Belum diisi';
  String get addressDisplay => address ?? 'Lokasi kandang belum diisi';
  
  bool get isProfileComplete {
    return name.isNotEmpty &&
        email.isNotEmpty &&
        phone != null &&
        phone!.isNotEmpty &&
        address != null &&
        address!.isNotEmpty;
  }

  String get profileStatus {
    if (isProfileComplete) {
      return 'Profil Kandang Lengkap';
    }
    return 'Profil Belum Lengkap';
  }
}