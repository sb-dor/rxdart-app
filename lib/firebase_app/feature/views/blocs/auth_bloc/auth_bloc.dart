import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart_app/firebase_app/feature/views/blocs/auth_bloc/auth_error.dart';

// states
@immutable
abstract class AuthStatus {
  const AuthStatus();
}

@immutable
class AuthStatusLogout extends AuthStatus {
  const AuthStatusLogout();
}

@immutable
class AuthStatusLoggedIn extends AuthStatus {
  const AuthStatusLoggedIn();
}

// events
@immutable
abstract class AuthCommand {
  final String email;
  final String password;

  const AuthCommand({required this.email, required this.password});
}

@immutable
class LoginCommand extends AuthCommand {
  const LoginCommand({required super.email, required super.password});
}

@immutable
class RegisterCommand extends AuthCommand {
  const RegisterCommand({required super.email, required super.password});
}

extension Loading<E> on Stream<E> {
  Stream<E> setLoadingTo(
    bool isLoading, {
    required Sink<bool> onSink,
  }) =>
      doOnEach(
        (notification) {
          onSink.add(isLoading);
        },
      );
}

@immutable
class AuthBloc {
  // read-only properties
  final Stream<AuthStatus> authStatus;
  final Stream<AuthError?> authError;
  final Stream<bool> isLoading;
  final Stream<String?> userId;

  //
  // write-only properties
  final Sink<LoginCommand> login;
  final Sink<RegisterCommand> register;
  final Sink<void> logOut;
  final Sink<void> deleteAccount;

  const AuthBloc._({
    required this.authStatus,
    required this.authError,
    required this.isLoading,
    required this.userId,
    required this.login,
    required this.register,
    required this.logOut,
    required this.deleteAccount,
  });

  factory AuthBloc() {
    final isLoading = BehaviorSubject<bool>();

    // calculate auth status (state)
    final Stream<AuthStatus> authStatusChanges =
        FirebaseAuth.instance.authStateChanges().map((user) {
      if (user != null) {
        return const AuthStatusLoggedIn();
      } else {
        return const AuthStatusLogout();
      }
    });

    // get the user id
    final Stream<String?> userId = FirebaseAuth.instance
        .authStateChanges()
        .map((user) => user?.uid)
        .startWith(FirebaseAuth.instance.currentUser?.uid);

    //
    //
    // login and error handling
    //
    final login = BehaviorSubject<LoginCommand>();

    // as soon as the login message is called we will use the extension "setLoadingTo" that we created above in
    // order to change the "isLoading" behaviorSubject (that was created above in this factory)
    //
    final Stream<AuthError?> loginError =
        // this is our extension
        login.setLoadingTo(true, onSink: isLoading).asyncMap<AuthError?>((loginCommand) async {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: loginCommand.email,
          password: loginCommand.password,
        );
        return null; // there is no any error
      } on FirebaseAuthException catch (e) {
        return AuthError.from(e);
      } catch (e) {
        return const AuthErrorUnknown();
      }
    }).setLoadingTo(false, onSink: isLoading);

    //
    //
    final register = BehaviorSubject<RegisterCommand>();

    // as soon as the login message is called we will use the extension "setLoadingTo" that we created above in
    // order to change the "isLoading" behaviorSubject (that was created above in this factory)
    //
    final Stream<AuthError?> registerError =
        // this is our extension
        register
            .setLoadingTo(true, onSink: isLoading)
            .asyncMap<AuthError?>((registerCommand) async {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: registerCommand.email,
          password: registerCommand.password,
        );
        return null; // there is no any error
      } on FirebaseAuthException catch (e) {
        return AuthError.from(e);
      } catch (e) {
        return const AuthErrorUnknown();
      }
    }).setLoadingTo(false, onSink: isLoading);

    //
    //
    final logOut = BehaviorSubject<void>();

    // as soon as the login message is called we will use the extension "setLoadingTo" that we created above in
    // order to change the "isLoading" behaviorSubject (that was created above in this factory)
    //
    final Stream<AuthError?> logOutError =
        // this is our extension
        logOut.setLoadingTo(true, onSink: isLoading).asyncMap<AuthError?>((logOutCommand) async {
      try {
        await FirebaseAuth.instance.signOut();
        return null; // there is no any error
      } on FirebaseAuthException catch (e) {
        return AuthError.from(e);
      } catch (e) {
        return const AuthErrorUnknown();
      }
    }).setLoadingTo(false, onSink: isLoading);

    final deleteAccountBehavior = BehaviorSubject<void>();

    final deleteAccountError =
        deleteAccountBehavior.setLoadingTo(true, onSink: isLoading).asyncMap((_) async {
      try {
        await FirebaseAuth.instance.currentUser?.delete();
        return null;
      } on FirebaseAuthException catch (e) {
        return AuthError.from(e);
      } catch (e) {
        return const AuthErrorUnknown();
      }
    }).setLoadingTo(false, onSink: isLoading);

    // auth error = (login error + register error + logout error)

    final Stream<AuthError?> authError = Rx.merge([
      loginError,
      registerError,
      logOutError,
      deleteAccountError,
    ]);

    return AuthBloc._(
      authStatus: authStatusChanges,
      authError: authError,
      isLoading: isLoading,
      userId: userId,
      login: login.sink,
      register: register.sink,
      logOut: logOut.sink,
      deleteAccount: deleteAccountBehavior.sink,
    );
  }

  void dispose() {
    login.close();
    register.close();
    logOut.close();
    deleteAccount.close();
  }
}
