import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twitter_login/entity/auth_result.dart';
import 'package:twitter_login/twitter_login.dart';

class AuthServices {
  final BuildContext context;
  AuthServices(this.context);

  Future<User?> googleSignUp() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? signInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication authentication =
          await signInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: authentication.idToken,
          accessToken: authentication.accessToken);
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential)
          .catchError((onError) {
        debugPrint(onError.toString());
      });
      User? user = userCredential.user;

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Google sign '),
          ),
        );
        return user;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unexpected error occured try after sometime'),
          ),
        );
        return Future.error("Unexpected error occurred try after sometime");
      }
    } catch (e) {
      debugPrint(e.toString());
      return Future.error(e.toString());
    }
  }

  Future<User?> signUpwithEmail(String email, String password) async {
    return await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      return value.user;
    }).catchError((onErr) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(onErr.toString())));
      return Future<User?>.error(onErr.toString());
    });
  }

  Future<User?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: [
          'public_profile',
          'email',
        ],
      ).then((value) {
        FacebookAuth.instance
            .getUserData(fields: "email,name,picture")
            .then((value) async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setString("PROFILE_URL", value['picture']['data']['url']);
          preferences.setString("PROFILE_NAME", value['name']);
          preferences.setString("PROFILE_ID", value['id']);
          preferences.setString("PROFILE_EMAIL", 'email');
        });
        return value;
      });

      if (result.status == LoginStatus.success) {
        // Create a credential from the access token
        final OAuthCredential credential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        // Once signed in, return the UserCredential
        UserCredential fCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        if (fCredential.user == null) {
          return Future.error("Can't fetch signup data");
        } else {
          return fCredential.user;
        }
      }
      if (result.status == LoginStatus.cancelled) {
        return Future.error("Cancelled by user");
      }
      if (result.status == LoginStatus.failed) {
        return Future.error("Facebook login failed");
      }
    } catch (e) {
      return Future.value(null);
    }
  }

  Future<User?> logInWithTwitter() async {
    TwitterLogin tLogin = TwitterLogin(
      apiKey: 'fAPOrhdUKEeBuqLX2V1kvMEIc',
      apiSecretKey: '5uFhoNTfUPeZtEwKIlXdzKb4EyStlxAczTmO9RPfsy6tO72WnQ',
      redirectURI: 'twittersdk://',
    );
    AuthResult result = await tLogin.login();

    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        AuthCredential credential = TwitterAuthProvider.credential(
            accessToken: result.authToken!, secret: result.authTokenSecret!);

        UserCredential tCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        User? user = tCredential.user;
        return user;
      case TwitterLoginStatus.cancelledByUser:
        return Future.error('Cancelled by user');
      case TwitterLoginStatus.error:
        return Future.error('An error occurred while loging in');
      default:
        return Future.error("Unexpected error occured code: e");
    }
  }

  Future<bool> updateSignInMethod(int v) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setInt('SIGN_IN_METHOD', v);
  }

  String extractPhotoUrl() {
    return FirebaseAuth.instance.currentUser!.photoURL!;
  }

  String extractEmail() {
    return FirebaseAuth.instance.currentUser!.email!;
  }

  String extractName() {
    return FirebaseAuth.instance.currentUser!.displayName!;
  }

  String? extractPhone() {
    return FirebaseAuth.instance.currentUser!.phoneNumber;
  }

  String extractUid() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  String? tenentUid() {
    return FirebaseAuth.instance.currentUser!.tenantId;
  }

  UserMetadata extractProviderData() {
    return FirebaseAuth.instance.currentUser!.metadata;
  }

  Future<String?> fbProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('PROFILE_URL');
  }

  Future<String?> fbName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('PROFILE_NAME');
  }

  Future<String?> fbEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('PROFILE_EMAIL');
  }

  Future<String?> fbID() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('PROFILE_ID');
  }

  Future<String?> goodName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('GOOD_NAME');
  }
}
