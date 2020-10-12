import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login {
  static final Login _instance = Login.internal();
  FirebaseUser _user;

  factory Login() => _instance;

  Login.internal();

  bool isLogged() {
    return _user != null;
  }

  bool isNotLogged() {
    return _user == null;
  }

  set user(FirebaseUser user) {
    _user = user;
  }

  Future<FirebaseUser> getUser() async {
    if (isLogged()) {
      return _user;
    }

    await auth();
    return _user;
  }

  Future<Login> auth() async {
    try {
      AuthCredential credential = await getGoogleCredentials();
      final AuthResult result =
          await FirebaseAuth.instance.signInWithCredential(credential);
      _user = result.user;
    } catch (error) {
      _user = null;
    }

    return this;
  }

  Future<AuthCredential> getGoogleCredentials() async {
    final GoogleSignIn google = GoogleSignIn();
    final GoogleSignInAccount account = await google.signIn();
    final GoogleSignInAuthentication auth = await account.authentication;
    return GoogleAuthProvider.getCredential(
      idToken: auth.idToken,
      accessToken: auth.accessToken,
    );
  }
}
