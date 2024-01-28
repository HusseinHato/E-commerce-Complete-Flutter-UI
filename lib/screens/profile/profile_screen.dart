import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:shop_app/screens/splash/splash_screen.dart';
import '../sign_in/sign_in_screen.dart';
import 'components/profile_menu.dart';
import 'components/profile_pic.dart';

const storage = FlutterSecureStorage();

class ProfileScreen extends StatefulWidget {
  static String routeName = "/profile";

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String emailAccount = "default";
  late String bearerToken;

  @override
  void initState() {
    super.initState();
    _fetchBearerTokenAndEmailAccount();
  }

  Future<void> _fetchBearerTokenAndEmailAccount() async {
    try {
      bearerToken = (await storage.read(key: 'jwt'))!;

      // print(bearerToken);

      final response = await Dio().get(
        'http://172.16.0.2:3000/admin/user',
        options: Options(headers: {'Authorization': "Bearer $bearerToken"}),
      );

      // print(response.data);

      if (response.statusCode == 200) {
        setState(() {
          emailAccount = response.data['data']['email']; // Adjust according to your API response structure
        });
      } else {
        throw Exception('Failed to load email account');
      }
    } catch (error) {
      throw Exception('Failed to load email account: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const ProfilePic(),
            const SizedBox(height: 20),
            emailAccount != null
                ? Text("Email Account : \n $emailAccount")
                : const CircularProgressIndicator(), // Show loading indicator while fetching email account
            ProfileMenu(
              text: "Log Out",
              icon: "assets/icons/Log out.svg",
              press: () {
                storage.deleteAll();
                Navigator.pushNamed(context, SplashScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
