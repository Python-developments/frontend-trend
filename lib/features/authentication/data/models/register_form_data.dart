class RegisterFormData {
  final String username;
  final String email;
  final String password;
  final String? fName;
  final String? lName;

  RegisterFormData({
    required this.username,
    required this.email,
    required this.password,
    this.fName,
    this.lName,
  });
}
