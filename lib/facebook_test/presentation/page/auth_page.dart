import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:test_face/facebook_test/presentation/page/wel_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final supabase = Supabase.instance.client;
  String? fullName;

  @override
  void initState() {
    super.initState();

    // استمع لتغير حالة الدخول
    supabase.auth.onAuthStateChange.listen((data) async {
      final session = data.session;
      if (session != null) {
        final user = supabase.auth.currentUser;
        if (user != null) {
          final metadata = user.userMetadata;
          final name = metadata?['name'] ?? metadata?['full_name'] ?? user.email;
          
          // عرض alert ثم الذهاب للصفحة
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: 'تم تسجيل الدخول بنجاح',
            confirmBtnText: 'موافق',
            onConfirmBtnTap: () {
              Navigator.of(context).pop(); // يغلق الـ Alert
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => WelcomePage(name: name),
              ));
            },
          );
        }
      }
    });
  }

  Future<void> signInWithFacebook() async {
    try {
      await supabase.auth.signInWithOAuth(
        OAuthProvider.facebook,
        redirectTo: 'lungcancer://login-callback',
      );
    } catch (e) {
      print('Error signing in: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل دخول فيسبوك')),
      body: Center(
        child: ElevatedButton(
          onPressed: signInWithFacebook,
          child: const Text('تسجيل الدخول باستخدام فيسبوك'),
        ),
      ),
    );
  }
}
