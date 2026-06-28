class GeneratePublicKeyModel {
  final String publicKey;

  GeneratePublicKeyModel({required this.publicKey});

  factory GeneratePublicKeyModel.fromJson(Map<String, dynamic> json) {
    return GeneratePublicKeyModel(publicKey: json["publicKey"] ?? "");
  }
}
