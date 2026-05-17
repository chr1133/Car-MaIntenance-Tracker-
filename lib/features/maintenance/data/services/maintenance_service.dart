import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/maintenance_model.dart';
import '../../../../core/constants/api_constants.dart';

class MaintenanceService {
  final String baseUrl = ApiConstants.baseUrl;

  // READ
  Future<List<MaintenanceModel>> fetchRecords() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => MaintenanceModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load records: ${response.statusCode}');
    }
  }

  // CREATE
  Future<MaintenanceModel> addRecord(MaintenanceModel record) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(record.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return MaintenanceModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add record: ${response.statusCode}');
    }
  }

  // UPDATE
  Future<MaintenanceModel> updateRecord(MaintenanceModel record) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${record.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(record.toJson()),
    );

    if (response.statusCode == 200) {
      return MaintenanceModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update record: ${response.statusCode}');
    }
  }

  // DELETE
  Future<void> deleteRecord(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete record: ${response.statusCode}');
    }
  }
}
