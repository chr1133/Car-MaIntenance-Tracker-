class MaintenanceModel {
  final String id;
  final String carName;
  final String serviceType;
  final String cost;
  final String date;
  final String notes;

  MaintenanceModel({
    required this.id,
    required this.carName,
    required this.serviceType,
    required this.cost,
    required this.date,
    required this.notes,
  });

  factory MaintenanceModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceModel(
      id: json['id'].toString(),
      carName: json['carName'] ?? '',
      serviceType: json['serviceType'] ?? '',
      cost: json['cost'] ?? '',
      date: json['date'] ?? '',
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'carName': carName,
      'serviceType': serviceType,
      'cost': cost,
      'date': date,
      'notes': notes,
    };
  }
}
