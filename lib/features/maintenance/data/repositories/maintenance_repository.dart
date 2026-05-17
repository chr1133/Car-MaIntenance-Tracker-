import '../models/maintenance_model.dart';
import '../services/maintenance_service.dart';

class MaintenanceRepository {
  final MaintenanceService _service = MaintenanceService();

  Future<List<MaintenanceModel>> fetchRecords() => _service.fetchRecords();
  Future<MaintenanceModel> addRecord(MaintenanceModel record) =>
      _service.addRecord(record);
  Future<MaintenanceModel> updateRecord(MaintenanceModel record) =>
      _service.updateRecord(record);
  Future<void> deleteRecord(String id) => _service.deleteRecord(id);
}
