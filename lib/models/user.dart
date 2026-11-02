class UserModel {
  final String uid;
  final String name;
  final String email;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
  });

  // Factory constructor untuk mengubah data dari Firebase Firestore (DocumentSnapshot) menjadi objek UserModel
  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      uid: documentId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
    );
  }

  // Mengubah objek UserModel kembali ke bentuk Map (biasanya untuk disimpan ke Firestore)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
    };
  }
}