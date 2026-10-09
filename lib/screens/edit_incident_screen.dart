import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../models/incident.dart';
import '../services/firestore_service.dart';

class EditIncidentScreen extends StatefulWidget {
  final Incident data;
  const EditIncidentScreen({super.key, required this.data});

  @override
  State<EditIncidentScreen> createState() => _EditIncidentScreenState();
}

class _EditIncidentScreenState extends State<EditIncidentScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirestoreService _fs = FirestoreService();
  late String _ticketNo;
  late String _attackType;
  late String _investigatorEmail;
  late double _cvssScore;
  late String _affectedEndpoints;

  @override
  void initState() {
    super.initState();
    _ticketNo = widget.data.ticketNo;
    _attackType = widget.data.attackType;
    _investigatorEmail = widget.data.investigatorEmail;
    _cvssScore = widget.data.cvssScore;
    _affectedEndpoints = widget.data.affectedEndpoints;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('แก้ไขข้อมูลเหตุการณ์')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _ticketNo,
                decoration: const InputDecoration(labelText: 'เลขที่บัตรคิว'),
                validator: RequiredValidator(errorText: 'จำเป็น'),
                onSaved: (v) => _ticketNo = v!,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _attackType,
                decoration: const InputDecoration(labelText: 'ประเภทภัย'),
                validator: RequiredValidator(errorText: 'จำเป็น'),
                onSaved: (v) => _attackType = v!,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _investigatorEmail,
                decoration: const InputDecoration(labelText: 'อีเมลผู้สืบสวน'),
                keyboardType: TextInputType.emailAddress,
                validator: EmailValidator(errorText: 'รูปแบบไม่ถูกต้อง'),
                onSaved: (v) => _investigatorEmail = v!,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _cvssScore.toString(),
                decoration: const InputDecoration(labelText: 'คะแนน CVSS'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final val = double.tryParse(v ?? '');
                  if (val == null || val < 0 || val > 10) return '0.0-10.0';
                  return null;
                },
                onSaved: (v) => _cvssScore = double.parse(v!),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _affectedEndpoints,
                decoration: const InputDecoration(labelText: 'จุดที่ได้รับผลกระทบ'),
                maxLines: 2,
                validator: RequiredValidator(errorText: 'จำเป็น'),
                onSaved: (v) => _affectedEndpoints = v!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    await _fs.updateIncident(
                      widget.data.id!,
                      Incident(
                        ticketNo: _ticketNo,
                        attackType: _attackType,
                        investigatorEmail: _investigatorEmail,
                        cvssScore: _cvssScore,
                        affectedEndpoints: _affectedEndpoints,
                      ),
                    );
                    if (mounted) Navigator.pop(context);
                  }
                },
                child: const Text('บันทึกการแก้ไข'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}