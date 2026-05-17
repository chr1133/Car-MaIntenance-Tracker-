import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/maintenance_model.dart';
import '../providers/maintenance_provider.dart';

class EditMaintenanceScreen extends StatefulWidget {
  final MaintenanceModel record;

  const EditMaintenanceScreen({super.key, required this.record});

  @override
  State<EditMaintenanceScreen> createState() => _EditMaintenanceScreenState();
}

class _EditMaintenanceScreenState extends State<EditMaintenanceScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _carNameController;
  late TextEditingController _serviceTypeController;
  late TextEditingController _costController;
  late TextEditingController _dateController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _carNameController = TextEditingController(text: widget.record.carName);
    _serviceTypeController =
        TextEditingController(text: widget.record.serviceType);
    _costController = TextEditingController(text: widget.record.cost);
    _dateController = TextEditingController(text: widget.record.date);
    _notesController = TextEditingController(text: widget.record.notes);
  }

  @override
  void dispose() {
    _carNameController.dispose();
    _serviceTypeController.dispose();
    _costController.dispose();
    _dateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.deepOrange,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      _dateController.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final updated = MaintenanceModel(
      id: widget.record.id,
      carName: _carNameController.text.trim(),
      serviceType: _serviceTypeController.text.trim(),
      cost: _costController.text.trim(),
      date: _dateController.text.trim(),
      notes: _notesController.text.trim(),
    );

    final success =
        await context.read<MaintenanceProvider>().updateRecord(updated);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(success ? 'Record updated!' : 'Failed to update record.'),
          backgroundColor: success ? Colors.deepOrange : Colors.red,
        ),
      );
      if (success) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Maintenance Record'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<MaintenanceProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildField(
                    controller: _carNameController,
                    label: 'Car Name',
                    icon: Icons.directions_car,
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    controller: _serviceTypeController,
                    label: 'Service Type',
                    icon: Icons.build,
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    controller: _costController,
                    label: 'Cost (ETB)',
                    icon: Icons.attach_money,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    onTap: _pickDate,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      prefixIcon: const Icon(
                        Icons.calendar_today,
                        color: Colors.deepOrange,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.deepOrange),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Please select a date' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    controller: _notesController,
                    label: 'Notes',
                    icon: Icons.notes,
                    maxLines: 3,
                    required: false,
                  ),
                  const SizedBox(height: 24),
                  if (provider.isLoading)
                    const CircularProgressIndicator(color: Colors.deepOrange)
                  else
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _submit,
                        icon: const Icon(Icons.update),
                        label: const Text(
                          'Update Record',
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool required = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepOrange),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.deepOrange),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: required
          ? (v) => v == null || v.isEmpty ? 'Please enter $label' : null
          : null,
    );
  }
}
