// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';
import '../../../helper/keyboard.dart';
import '../../forgot_password/forgot_password_screen.dart';
import '../../login_success/login_success_screen.dart';

final dio = Dio();
const storage = FlutterSecureStorage();

class SignForm extends StatefulWidget {
  const SignForm({super.key});

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

  bool? remember = false;
  final List<String?> errors = [];

  bool? success;

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  Future<void> login() async {
    // var url = Uri.http("10.10.30.122", '/mobile/login.php', {'q': '{http}'});

    try {
      final response = await dio.post('http://localhost:3000/login', data: {
        "email": email.text,
        "password": pass.text
      });

      print(response.statusCode);

      if (response.statusCode == 200) {
        var data = response.data;

        print(data);

        await storage.write(key: 'jwt', value: data["token"]);

        if (data["message"] == "success") {
          Navigator.pushNamed(context, LoginSuccessScreen.routeName);
        }
      } else if(response.statusCode == 400) {
        // Handle non-200 status code
        showErrorMessage('Invalid Credentials');
      } else {
        showErrorMessage("Something Wrong");
      }
    } catch (error) {
      // Handle other errors
      showErrorMessage('An error occurred: $error');
    }
  }

  void showErrorMessage(String message) {
    Fluttertoast.showToast(
      backgroundColor: Colors.deepOrange,
      textColor: Colors.white,
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
      gravity: ToastGravity.CENTER
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
            children: [
              TextFormField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                onSaved: (newValue) => email = newValue as TextEditingController,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    removeError(error: kEmailNullError);
                  } else if (emailValidatorRegExp.hasMatch(value)) {
                    removeError(error: kInvalidEmailError);
                  }
                  return;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    addError(error: kEmailNullError);
                    return "";
                  } else if (!emailValidatorRegExp.hasMatch(value)) {
                    addError(error: kInvalidEmailError);
                    return "";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Email",
                  hintText: "Enter your email",
                  // If  you are using latest version of flutter then lable text and hint text shown like this
                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: pass,
                obscureText: true,
                onSaved: (newValue) => pass = newValue as TextEditingController,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    removeError(error: kPassNullError);
                  } else if (value.length >= 8) {
                    removeError(error: kShortPassError);
                  }
                  return;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    addError(error: kPassNullError);
                    return "";
                  } else if (value.length < 8) {
                    addError(error: kShortPassError);
                    return "";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintText: "Enter your password",
                  // If  you are using latest version of flutter then lable text and hint text shown like this
                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
                ),
              ),
              const SizedBox(height: 20),
              // Row(
                // children: [
                //   Checkbox(
                //     value: remember,
                //     activeColor: kPrimaryColor,
                //     onChanged: (value) {
                //       setState(() {
                //         remember = value;
                //       });
                //     },
                //   ),
                //   const Text("Remember me"),
                  // const Spacer(),
                  // GestureDetector(
                  //   onTap: () => Navigator.pushNamed(
                  //       context, ForgotPasswordScreen.routeName),
                  //   child: const Text(
                  //     "Forgot Password",
                  //     style: TextStyle(decoration: TextDecoration.underline),
                  //   ),
                  // )
                // ],
              // ),
              FormError(errors: errors),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // if (_formKey.currentState!.validate()) {
                    // _formKey.currentState!.save();
                    // if all are valid then go to success screen
                    login();
                  // }
                },
                child: const Text("Continue"),
              ),
            ],
            ),
        );
    }
}