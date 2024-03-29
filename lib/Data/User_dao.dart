import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class UserDao extends ChangeNotifier {
  final auth = FirebaseAuth.instance;
  User usuario;
  String errorMessage;
  UserCredential user;

// TODO: Add helper methods - Métodos de ajuda
  bool isLoggedIn() {
    return auth.currentUser != null;
  }

  String userId() {
    return auth.currentUser?.uid;
  }

  String email() {
    return auth.currentUser?.email;
  }
  // ImgUsuario.src = user.photoURL ? user.photoURL : 'IMGs/usuarioIMG.png'

  String photoURL() {
    return auth.currentUser?.photoURL ?? 'assets/image/logo_user.png';
    //return auth.currentUser?.photoURL;
  }

  _getUser() {
    usuario = auth.currentUser;
    notifyListeners();
  }

  void updatePassword(String password, String newPassword) async {
    try {
      final cred =
          EmailAuthProvider.credential(email: email(), password: password);

      auth.currentUser.reauthenticateWithCredential(cred).then((value) {
        auth.currentUser.updatePassword(newPassword).then((value) {
          Fluttertoast.showToast(
              msg: "Senha atualizada com sucesso!",
              gravity: ToastGravity.SNACKBAR);
        }).catchError((e) {
          errorMessage = "";
          if (e.code == "weak-password") {
            errorMessage = "Senha muito fraca";
          }
          Fluttertoast.showToast(
              msg: "A senha não pôde ser atualizada! " + errorMessage,
              gravity: ToastGravity.SNACKBAR);
        });
      }).catchError((e) {
        errorMessage = "";
        if (e.code == "wrong-password") {
          errorMessage = "Senha incorreta";
        }
        Fluttertoast.showToast(
            msg: "A senha não pôde ser atualizada! " + errorMessage,
            gravity: ToastGravity.SNACKBAR);
      });
    } catch (e) {
      debugPrint(e);
    }
  }

  void signup(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        //throw AuthException('Sua senha é muito fraca');
        errorMessage = 'Sua senha é muito fraca';
      } else if (e.code == 'email-already-in-use') {
        //throw AuthException('Este email já está cadastrado');
        errorMessage = 'Este email já está cadastrado';
      }

      Fluttertoast.showToast(msg: errorMessage, gravity: ToastGravity.BOTTOM);
    } catch (e) {
      debugPrint(e);
    }
  }

// TODO: Add login - Entrar no App
  void login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _getUser();
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        //throw AuthException('Senha incorreta. Tente novamente');
        errorMessage = 'Senha incorreta. Tente novamente';
      } else if (e.code == 'user-not-found') {
        //throw AuthException('Email não encontrado. Cadastre-se');
        errorMessage = 'Email não encontrado. Cadastre-se';
      }

      Fluttertoast.showToast(msg: errorMessage, gravity: ToastGravity.SNACKBAR);
    } catch (e) {
      debugPrint(e);
    }
  }

// TODO: Add logout -  Sair do App
  void logout() async {
    await auth.signOut();
    notifyListeners();
    _getUser();
  }

// TODO: Sing In with Google
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await auth
        .signInWithCredential(credential)
        .then((userCredential) => {user = userCredential});
    //return await auth.signInWithCredential(credential);
    _getUser();
    notifyListeners();
  }

  // TODO: Sing In with Facebook
  void signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final userData = await FacebookAuth.instance.getUserData();

      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken.token);
      await auth.signInWithCredential(facebookAuthCredential);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        debugPrint('erro de autentificação');
      }
    }
  }
}
