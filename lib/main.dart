import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:test_face/facebook_test/data/auth_repository_impl.dart';
import 'package:test_face/facebook_test/domain/auth_repository.dart';
import 'package:test_face/facebook_test/presentation/cubit/auth_cubit.dart';
import 'package:test_face/facebook_test/presentation/page/auth_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  final supabaseUrl = dotenv.env['SUPABASE_URL']!;

  final supabaseKey = dotenv.env['SUPABASE_ANON_KEY']!;

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );

  final authRepository = AuthRepositoryImpl();

  runApp(MyApp(authRepository: authRepository));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;
  const MyApp({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Facebook Login Clean Architecture',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider(
        create: (_) => AuthCubit(authRepository),
        child: const AuthPage(),
      ),
    );
  }
}
