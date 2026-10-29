
String? validateUsernameInput(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Username atau email tidak boleh kosong';
  }
  return null;
}

String? validatePasswordInput(String? value) {
  if (value == null || value.isEmpty) {
    return 'Kata sandi tidak boleh kosong';
  }
  if (value.length < 6) {
    return 'Kata sandi minimal 6 karakter';
  }
  return null;
}