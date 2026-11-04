String? validateEmailInput(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Email tidak boleh kosong';
  }
  if (!value.contains('@') || !value.contains('.')) {
    return 'Format email tidak valid';
  }
  return null;
}

String? validatePasswordInput(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password tidak boleh kosong';
  }
  if (value.length < 6) {
    return 'Password minimal 6 karakter';
  }
  return null;
}