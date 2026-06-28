class LoginResponseModel {
  final String token;
  final String userName;
  final String fullName;
  final DateTime expiresAt;

  LoginResponseModel({
    required this.token,
    required this.userName,
    required this.fullName,
    required this.expiresAt,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['token'] ?? '',
      userName: json['userName'] ?? '',
      fullName: json['fullName'] ?? '',
      expiresAt: DateTime.parse(json['expiresAt']),
    );
  }
}
