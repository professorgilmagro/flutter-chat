import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  static final Auth _instance = Auth.internal();
  FirebaseUser _user;
  GoogleSignIn _google;
  bool _fails = false;

  factory Auth() => _instance;

  Auth.internal();

  bool isLogged() {
    return _user != null;
  }

  bool isNotLogged() {
    return _user == null;
  }

  String get uid {
    return isLogged() ? _user.uid : null;
  }

  String get name {
    return isLogged() ? _user.displayName : null;
  }

  String get avatarUrl {
    return isLogged() ? _user.photoUrl : null;
  }

  bool get isLoginFails {
    return _fails;
  }

  set user(FirebaseUser user) {
    _user = user;
  }

  Future<FirebaseUser> getUser() async {
    if (isLogged()) {
      return _user;
    }

    await signIn();
    return _user;
  }

  Future<Auth> signIn() async {
    try {
      AuthCredential credential = await getGoogleCredentials();
      final AuthResult result =
          await FirebaseAuth.instance.signInWithCredential(credential);
      _user = result.user;
    } catch (error) {
      _user = null;
      _fails = true;
    }

    return this;
  }

  signOut() {
    FirebaseAuth.instance.signOut();
    _google.signOut();
  }

  Future<AuthCredential> getGoogleCredentials() async {
    _google = GoogleSignIn();
    final GoogleSignInAccount account = await _google.signIn();
    final GoogleSignInAuthentication auth = await account.authentication;
    return GoogleAuthProvider.getCredential(
      idToken: auth.idToken,
      accessToken: auth.accessToken,
    );
  }
}
