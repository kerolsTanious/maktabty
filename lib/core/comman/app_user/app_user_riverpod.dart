import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/auth/data/repository/auth_repository.dart';
import '../entitys/user_model.dart';
import '../helpers/secure_storage_helper.dart';
import 'app_user_state.dart';

final appUserRiverpodProvider =
    StateNotifierProvider<AppUserRiverpod, AppUserRiverpodState>((ref) {
  return AppUserRiverpod(
    repository: ref.watch(authRepositoryProvider),
  );
});

class AppUserRiverpod extends StateNotifier<AppUserRiverpodState> {
  final AuthRepository _authRepository;

  AppUserRiverpod({
    required AuthRepository repository,
  })  : _authRepository = repository,
        super(AppUserRiverpodState.initial());

  Future<void> saveUserData(UserModel? user) async {
    state = state.copyWith(state: AppUserStates.loading);
    if (user != null) {
      final res = await SecureStorageHelper.saveUserData(user);
      res.fold(
        (l) => state = state.copyWith(
          state: AppUserStates.failureSaveData,
          errorMessage: l,
        ),
        (r) {
          state = state.copyWith(
            state: AppUserStates.gettedDataFromLocalStorage,
            user: user,
          );
        },
      );
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(state: AppUserStates.loading);
    final res = await SecureStorageHelper.removeUserData();
    res.fold(
      (l) => state = state.copyWith(
        state: AppUserStates.failure,
        errorMessage: 'Failed to sign out',
      ),
      (r) => state = state.copyWith(
        state: AppUserStates.notLoggedIn,
        user: null,
      ),
    );
  }

  Future<void> getUser(String email) async {
    state = state.copyWith(state: AppUserStates.loading);
    final result = await _authRepository.getCurrentUser(email);
    result.fold(
      (l) => state = state.copyWith(
        state: AppUserStates.failure,
        errorMessage: l.message,
      ),
      (r) async {
        if (r != null) {
          await saveUserData(r);
        } else {
          state = state.copyWith(
            state: AppUserStates.failure,
            errorMessage: "User not found",
          );
        }
      },
    );
  }

  Future<void> isUserLoggedIn() async {
    state = state.copyWith(state: AppUserStates.loading);
    final res = await SecureStorageHelper.isUserLoggedIn();
    res.fold(
      (l) => state = state.copyWith(
        state: AppUserStates.notLoggedIn,
        errorMessage: l,
      ),
      (r) async {
        await saveUserData(r);
      },
    );
  }

  Future<void> getStoredUserData() async {
    state = state.copyWith(state: AppUserStates.loading);
    final res = await SecureStorageHelper.getUserData();
    res.fold(
      (l) => state = state.copyWith(
        state: AppUserStates.failure,
        errorMessage: l,
      ),
      (r) => state = state.copyWith(
        state: AppUserStates.gettedDataFromLocalStorage,
        user: r,
      ),
    );
  }

  Future<void> signOutFromEmailAndPassword() async {
    state = state.copyWith(state: AppUserStates.loading);
    final res = await _authRepository.signOut();
    res.fold(
      (l) => state = state.copyWith(
        state: AppUserStates.failure,
        errorMessage: l.message,
      ),
      (r) {
        state = state.copyWith(state: AppUserStates.signOut);
      },
    );
  }

  Future<void> isFirstInstallation() async {
    if (state.isLoading()) return; // Prevent multiple calls

    state = state.copyWith(state: AppUserStates.loading);
    final res = await SecureStorageHelper.isFirstInstallation();

    if (mounted) {
      // Check if the provider is still mounted
      res.fold(
          (l) => state = state.copyWith(
                state: AppUserStates.notInstalled,
                errorMessage: l,
              ), (r) {
        state = state.copyWith(
          state: AppUserStates.installed,
        );
        isUserLoggedIn();
      });
    }
  }

  Future<void> saveInstallationFlag() async {
    state = state.copyWith(state: AppUserStates.loading);
    final res = await SecureStorageHelper.saveInstalltionFlag();
    res.fold(
      (l) => state = state.copyWith(
        state: AppUserStates.failure,
        errorMessage: l,
      ),
      (r) => state = state.copyWith(
        state: AppUserStates.installed,
      ),
    );
  }

  Future<void> clearUserData() async {
    state = state.copyWith(state: AppUserStates.loading);
    final res = await SecureStorageHelper.removeUserData();
    res.fold(
        (l) => state = state.copyWith(
              state: AppUserStates.failure,
              errorMessage: l,
            ), (r) {
      state = state.copyWith(
        state: AppUserStates.clearUserData,
        user: null,
      );
      signOutFromEmailAndPassword();
    });
  }

  Future<void> saveUserToSupabase(UserModel? user) async {
    state = state.copyWith(state: AppUserStates.loading);
    if (user != null) {
      final res = await _authRepository.createUserProfile(user: user);
      res.fold(
        (l) => state = state.copyWith(
          state: AppUserStates.failureSaveUserDataInSupabase,
          errorMessage: l.message,
        ),
        (r) => state = state.copyWith(
          state: AppUserStates.saveUserDataInSupabase,
          user: user,
        ),
      );
    }
  }
}
