import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class UserFormScreen extends StatefulWidget {
  final User? user;

  const UserFormScreen({super.key, this.user});

  @override
  _UserFormScreenState createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numberPhoneController = TextEditingController();
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _nameController.text = widget.user!.name;
      _countryController.text = capitalizeFirstLetter(widget.user!.country);
      _addressController.text = widget.user!.address ?? '';
      _emailController.text = widget.user!.email ?? '';
      _numberPhoneController.text = widget.user!.numberPhone ?? '';
      _selectedGender = widget.user!.gender.toLowerCase() == "masculino"
          ? "Masculino"
          : "Femenino";
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _countryController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _numberPhoneController.dispose();
    super.dispose();
  }

  String capitalizeFirstLetter(String country) {
    if (country.isEmpty) return country;
    return country[0].toUpperCase() + country.substring(1).toLowerCase();
  }

  void _saveUser() async {
    if (_formKey.currentState!.validate()) {
      final apiService = ApiService();
      final user = User(
        id: widget.user?.id ?? 0,
        name: _nameController.text,
        gender: _selectedGender ?? "Masculino",
        country: capitalizeFirstLetter(_countryController.text),
        address: _addressController.text,
        email: _emailController.text,
        numberPhone: _numberPhoneController.text,
      );
      try {
        if (widget.user == null) {
          await apiService.createUser(user);
        } else {
          await apiService.updateUser(user);
        }
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar usuario: $e')),
        );
      }
    }
  }

  String? _validateField(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingrese $fieldName';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? 'Agregar Usuario' : 'Editar Usuario'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_nameController, 'Nombre'),
              _buildDropdownField(),
              _buildTextField(_countryController, 'País'),
              _buildTextField(_addressController, 'Dirección'),
              _buildTextField(
                  _emailController, 'Correo', TextInputType.emailAddress),
              _buildTextField(
                  _numberPhoneController, 'Teléfono', TextInputType.phone),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Guardar', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      [TextInputType keyboardType = TextInputType.text]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) => _validateField(value, label.toLowerCase()),
      ),
    );
  }

  Widget _buildDropdownField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: _selectedGender,
        decoration: InputDecoration(
          labelText: 'Género',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: ['Masculino', 'Femenino']
            .map((gender) => DropdownMenuItem(
                  value: gender,
                  child: Text(gender),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedGender = value!;
          });
        },
        validator: (value) => value == null ? 'Seleccione un género' : null,
      ),
    );
  }
}
