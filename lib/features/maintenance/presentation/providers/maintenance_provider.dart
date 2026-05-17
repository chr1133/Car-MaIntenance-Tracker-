import 'package:flutter/foundation.dart';
import '../../data/models/maintenance_model.dart';
import '../../data/repositories/maintenance_repository.dart';

class MaintenanceProvider extends ChangeNotifier {
  final MaintenanceRepository _repository = MaintenanceRepository();

  List<MaintenanceModel> _records = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<MaintenanceModel> get records => _records;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  // READ
  Future<void> fetchRecords() async {
    _setLoading(true);
    _setError(null);
    try {
      _records = await _repository.fetchRecords();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // CREATE
  Future<bool> addRecord(MaintenanceModel record) async {
    _setLoading(true);
    _setError(null);
    try {
      final newRecord = await _repository.addRecord(record);
      _records.add(newRecord);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // UPDATE
  Future<bool> updateRecord(MaintenanceModel record) async {
    _setLoading(true);
    _setError(null);
    try {
      final updated = await _repository.updateRecord(record);
      final index = _records.indexWhere((r) => r.id == record.id);
      if (index != -1) {
        _records[index] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // DELETE
  Future<bool> deleteRecord(String id) async {
    _setLoading(true);
    _setError(null);
    try {
      await _repository.deleteRecord(id);
      _records.removeWhere((r) => r.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
