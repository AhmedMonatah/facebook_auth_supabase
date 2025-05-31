import 'user_entity.dart';

abstract class AuthRepository {
  Future<void> signInWithFacebook();
  Future<void> signOut();
  Future<UserEntity?> getCurrentUser();
  Stream<UserEntity?> onAuthStateChanged();
}
