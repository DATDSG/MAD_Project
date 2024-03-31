import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  // google sign in
  signInwithGoogle() async {
    // interactive sign in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    // obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    // crate new credentials for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // sign in process
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }


  // signInwithFacebook() async{
  //   final FacebookSignInAccount? facebookUser = await FacebookSignIn().signIn();
  //   final FacebookSignInAuthentication facebookAuth = await facebookUser!.authentication;
  //   final AuthCredential credential = FacebookAuthProvider.credential(accessToken: facebookAuth.accessToken);
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }
}
