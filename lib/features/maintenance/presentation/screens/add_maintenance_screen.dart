import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/maintenance_model.dart';
import '../providers/maintenance_provider.dart';

class AddMaintenanceScreen extends StatefulWidget {
  const AddMaintenanceScreen({super.key});

  @override
  State<AddMaintenanceScreen> createState() => _AddMaintenanceScreenState();
}

class _AddMaintenanceScreenState extends State<AddMaintenanceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _carNameController = TextEditingController();
  final _serviceTypeController = TextEditingController();
  final _costController = TextEditingController();
  final _dateController = TextEditingController();
  final _notesController = TextEditingController();

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

    final record = MaintenanceModel(
      id: '',
      carName: _carNameController.text.trim(),
      serviceType: _serviceTypeController.text.trim(),
      cost: _costController.text.trim(),
      date: _dateController.text.trim(),
      notes: _notesController.text.trim(),
    );

    final success = await context.read<MaintenanceProvider>().addRecord(record);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Record added!' : 'Failed to add record.'),
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
        title: const Text('Add Maintenance Record'),
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
                    hint: 'e.g. Toyota Corolla',
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    controller: _serviceTypeController,
                    label: 'Service Type',
                    icon: Icons.build,
                    hint: 'e.g. Oil Change',
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    controller: _costController,
                    label: 'Cost (ETB)',
                    icon: Icons.attach_money,
                    hint: 'e.g. 2500',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    onTap: _pickDate,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      hintText: 'Select a date',
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
                    hint: 'Optional notes...',
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
                        icon: const Icon(Icons.save),
                        label: const Text(
                          'Save Record',
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
    String? hint,
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
        hintText: hint,
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
