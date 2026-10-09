import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../models/incident.dart';
import '../services/firestore_service.dart';

class AddIncidentScreen extends StatefulWidget {
  const AddIncidentScreen({super.key});

  @override
  State<AddIncidentScreen> createState() => _AddIncidentScreenState();
}

class _AddIncidentScreenState extends State<AddIncidentScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirestoreService _fs = FirestoreService();
  String _ticketNo = '';
  String _attackType = '';
  String _investigatorEmail = '';
  double _cvssScore = 0;
  String _affectedEndpoints = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('บันทึกเหตุการณ์')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'เลขที่บัตรคิว (เช่น SOC-INC-001)'),
                validator: RequiredValidator(errorText: 'กรุณากรอกเลขที่บัตรคิว'),
                onSaved: (v) => _ticketNo = v!,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'ประเภทภัยคุกคาม'),
                validator: RequiredValidator(errorText: 'กรุณาระบุประเภทภัย'),
                onSaved: (v) => _attackType = v!,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'อีเมลผู้สืบสวน'),
                keyboardType: TextInputType.emailAddress,
                validator: MultiValidator([
                  RequiredValidator(errorText: 'กรุณากรอกอีเมล'),
                  EmailValidator(errorText: 'รูปแบบอีเมลไม่ถูกต้อง'),
                ]),
                onSaved: (v) => _investigatorEmail = v!,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'คะแนน CVSS (0.0-10.0)'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'กรุณากรอกคะแนน';
                  final val = double.tryParse(v);
                  if (val == null || val < 0 || val > 10) {
                    return 'ต้องอยู่ระหว่าง 0.0-10.0';
                  }
                  return null;
                },
                onSaved: (v) => _cvssScore = double.parse(v!),
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'จุดที่ได้รับผลกระทบ'),
                maxLines: 2,
                validator: RequiredValidator(errorText: 'กรุณาระบุจุดที่ได้รับผลกระทบ'),
                onSaved: (v) => _affectedEndpoints = v!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    await _fs.addIncident(Incident(
                      ticketNo: _ticketNo,
                      attackType: _attackType,
                      investigatorEmail: _investigatorEmail,
                      cvssScore: _cvssScore,
                      affectedEndpoints: _affectedEndpoints,
                    ));
                    if (mounted) Navigator.pop(context);
                  }
                },
                child: const Text('บันทึกข้อมูล'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}