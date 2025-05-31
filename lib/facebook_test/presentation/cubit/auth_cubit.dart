import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit(this.authRepository) : super(AuthInitial()) {
    _monitorAuthChanges();
  }

  Future<void> loginWithFacebook() async {
    emit(AuthLoading());
    try {
      await authRepository.signInWithFacebook();
    } catch (e) {
      emit(AuthError('فشل تسجيل الدخول: $e'));
    }
  }

  Future<void> logout() async {
    await authRepository.signOut();
    emit(Unauthenticated());
  }

  void _monitorAuthChanges() {
    authRepository.onAuthStateChanged().listen((user) {
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    });
  }
}
