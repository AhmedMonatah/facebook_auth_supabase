import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/auth_repository.dart';
import '../domain/user_entity.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Future<void> signInWithFacebook() async {
    await supabase.auth.signInWithOAuth(
      OAuthProvider.facebook,
      redirectTo: 'lungcancer://login-callback',
    );
  }

  @override
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;

    final metadata = user.userMetadata;
    return UserEntity(
      fullName: metadata?['name'] ?? metadata?['full_name'] ?? user.email,
      email: user.email,
    );
  }

  @override
  Stream<UserEntity?> onAuthStateChanged() {
    return supabase.auth.onAuthStateChange.map((event) {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return null;
      final metadata = user.userMetadata;
      return UserEntity(
        fullName: metadata?['name'] ?? metadata?['full_name'] ?? user.email,
        email: user.email,
      );
    });
  }
}
