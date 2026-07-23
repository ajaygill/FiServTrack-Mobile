class LoanTypesModel {
  LoanTypesModel({
    required this.name,
    required this.isActive,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? name;
  final bool? isActive;
  final int? id;
  final DateTime? createdAt;
  final dynamic updatedAt;

  factory LoanTypesModel.fromJson(Map<String, dynamic> json) {
    return LoanTypesModel(
      name: json["name"],
      isActive: json["isActive"],
      id: json["id"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: json["updatedAt"],
    );
  }
}
