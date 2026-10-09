import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthController _auth = AuthController();
  String _email = '', _pass = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('SOCAlert', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('ระบบตอบสนองและรายงานเหตุการณ์ไซเบอร์'),
                const SizedBox(height: 32),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'อีเมล'),
                  keyboardType: TextInputType.emailAddress,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'กรุณากรอกอีเมล'),
                    EmailValidator(errorText: 'รูปแบบไม่ถูกต้อง'),
                  ]),
                  onSaved: (v) => _email = v!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'รหัสผ่าน'),
                  obscureText: true,
                  validator: RequiredValidator(errorText: 'กรุณากรอกรหัสผ่าน'),
                  onSaved: (v) => _pass = v!,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      try {
                        await _auth.signIn(_email, _pass);
                        if (mounted) {
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('เข้าสู่ระบบล้มเหลว: $e')),
                          );
                        }
                      }
                    }
                  },
                  child: const Text('เข้าสู่ระบบ', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 16),
                const Text('ทดสอบ: admin@test.com / operator@test.com'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}