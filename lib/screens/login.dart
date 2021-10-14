import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_to/screens/profile.dart';
import 'package:login_to/services/auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with WidgetsBindingObserver {
  bool _checked = false;
  bool isError = false;
  bool isEmailLogin = false;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    //final height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () {
        if (isError) {
          return Future.value(true);
        }
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("In Progress")));
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 32,
                ),
                Container(
                  alignment: Alignment.center,
                  //color: Colors.deepOrange,
                  child: Image.asset(
                    'assets/svg/wfh_1.png',
                    width: width * 0.6,
                    height: width * 0.6,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Sign up to LoginTo",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF130f40),
                    fontSize: 25,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 3.0,
                ),
                Text(
                  "Hi! you need to login/signup to continue.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFF130f40),
                    fontSize: 15,
                    letterSpacing: 1,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: OutlinedButton(
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              elevation: 0,
                              insetPadding: EdgeInsets.zero,
                              contentPadding: EdgeInsets.zero,
                              backgroundColor: Colors.transparent,
                              content: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(36, 36, 36, 0),
                                  width: width,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: FutureBuilder<User?>(
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        if (snapshot.data == null) {
                                          isError = true;
                                          return signInProgress(
                                              width,
                                              true,
                                              false,
                                              'assets/svg/google.svg',
                                              "",
                                              0);
                                        } else {
                                          AuthServices(context)
                                              .updateSignInMethod(0);
                                          return signInProgress(
                                              width,
                                              false,
                                              false,
                                              'assets/svg/google.svg',
                                              "",
                                              0);
                                        }
                                      } else if (snapshot.hasError) {
                                        isError = true;
                                        return signInProgress(
                                            width,
                                            true,
                                            false,
                                            'assets/svg/google.svg',
                                            snapshot.error,
                                            0);
                                      } else {
                                        return signInProgress(width, true, true,
                                            'assets/svg/google.svg', "", 0);
                                      }
                                    },
                                    future:
                                        AuthServices(context).googleSignUp(),
                                  ),
                                ),
                              ),
                            ),
                          );
                          //User? user = await AuthServices(context).googleSignUp();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/svg/google.svg',
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(
                                width: 6.0,
                              ),
                              Text(
                                'Sign up with Google',
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF3c3c3c),
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    elevation: 0,
                                    insetPadding: EdgeInsets.zero,
                                    contentPadding: EdgeInsets.zero,
                                    backgroundColor: Colors.transparent,
                                    content: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            36, 36, 36, 0),
                                        width: width,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(16),
                                            topRight: Radius.circular(16),
                                          ),
                                          color: Colors.white,
                                        ),
                                        child: FutureBuilder<User?>(
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              AuthServices(context)
                                                  .updateSignInMethod(1);
                                              return signInProgress(
                                                  width,
                                                  false,
                                                  false,
                                                  'assets/svg/facebook.svg',
                                                  snapshot.error,
                                                  1);
                                            } else if (snapshot.hasError) {
                                              isError = true;
                                              return signInProgress(
                                                  width,
                                                  true,
                                                  false,
                                                  'assets/svg/facebook.svg',
                                                  snapshot.error,
                                                  1);
                                            } else {
                                              return signInProgress(
                                                  width,
                                                  false,
                                                  true,
                                                  'assets/svg/facebook.svg',
                                                  "",
                                                  1);
                                            }
                                          },
                                          future: AuthServices(context)
                                              .signInWithFacebook(),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                                //AuthServices(context).signInWithFacebook();
                              },
                              child: Container(
                                //margin: const EdgeInsets.symmetric(horizontal: 8.0),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF2f2f2),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: SvgPicture.asset(
                                  'assets/svg/facebook.svg',
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            ),
                            flex: 1,
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    elevation: 0,
                                    insetPadding: EdgeInsets.zero,
                                    contentPadding: EdgeInsets.zero,
                                    backgroundColor: Colors.transparent,
                                    content: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            36, 36, 36, 0),
                                        width: width,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(16),
                                            topRight: Radius.circular(16),
                                          ),
                                          color: Colors.white,
                                        ),
                                        child: FutureBuilder<User?>(
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              AuthServices(context)
                                                  .updateSignInMethod(1);
                                              return signInProgress(
                                                  width,
                                                  false,
                                                  false,
                                                  'assets/svg/twitter.svg',
                                                  snapshot.error,
                                                  3);
                                            } else if (snapshot.hasError) {
                                              isError = true;
                                              return signInProgress(
                                                  width,
                                                  true,
                                                  false,
                                                  'assets/svg/twitter.svg',
                                                  snapshot.error,
                                                  3);
                                            } else {
                                              return signInProgress(
                                                  width,
                                                  false,
                                                  true,
                                                  'assets/svg/twitter.svg',
                                                  "",
                                                  3);
                                            }
                                          },
                                          future: AuthServices(context)
                                              .logInWithTwitter(),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF2f2f2),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: SvgPicture.asset(
                                  'assets/svg/twitter.svg',
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            ),
                            flex: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "- OR -",
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF3c3c3c),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFFF2f2f2,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                      style: GoogleFonts.poppins(),
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Email address',
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        border: InputBorder.none,
                      ),
                      controller: _email),
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFFF2f2f2,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    style: GoogleFonts.poppins(),
                    keyboardType: TextInputType.visiblePassword,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      border: InputBorder.none,
                    ),
                    controller: _password,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _checked,
                      onChanged: (b) {
                        setState(() {
                          _checked = b!;
                        });
                      },
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'By sign up you agress to our ',
                              style: GoogleFonts.montserrat(
                                color: const Color(0xFF3c3c3c),
                              ),
                            ),
                            TextSpan(
                              text: 'terms & condition',
                              style: GoogleFonts.montserrat(
                                color: Colors.deepPurpleAccent,
                              ),
                            ),
                            TextSpan(
                              text: ' and ',
                              style: GoogleFonts.montserrat(
                                color: const Color(0xFF3c3c3c),
                              ),
                            ),
                            TextSpan(
                              text: 'Privacy policy',
                              style: GoogleFonts.montserrat(
                                color: Colors.deepPurpleAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 18,
                ),
                GestureDetector(
                  onTap: () {
                    if (_checked) {
                      if (_email.text.isNotEmpty) {
                        if (_password.text.isNotEmpty ||
                            _password.text.length > 6) {
                          isEmailLogin = true;
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              elevation: 0,
                              insetPadding: EdgeInsets.zero,
                              contentPadding: EdgeInsets.zero,
                              backgroundColor: Colors.transparent,
                              content: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(36, 36, 36, 0),
                                  width: width,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: FutureBuilder<User?>(
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.email_outlined,
                                              color: Colors.deepPurpleAccent,
                                            ),
                                            const SizedBox(
                                              height: 24,
                                            ),
                                            const Icon(
                                              Icons.done_outline,
                                              color: Colors.greenAccent,
                                            ),
                                            const SizedBox(
                                              height: 24,
                                            ),
                                            Container(
                                              width: width,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                color: const Color(0xFFF2f2f2),
                                              ),
                                              child: TextField(
                                                controller: _nameController,
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(),
                                                decoration:
                                                    const InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'Your name',
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 24,
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                if (_nameController
                                                    .text.isNotEmpty) {
                                                  SharedPreferences
                                                      preferences =
                                                      await SharedPreferences
                                                          .getInstance();

                                                  preferences.setString(
                                                      'GOOD_NAME',
                                                      _nameController.text);

                                                  preferences.setInt(
                                                      "SIGN_IN_METHOD", 2);

                                                  Navigator.pop(context);
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const Profile(
                                                                  methodNo:
                                                                      2)));
                                                }
                                              },
                                              child: Container(
                                                width: width,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          24.0),
                                                  color:
                                                      Colors.deepPurpleAccent,
                                                ),
                                                child: Text(
                                                  "Continue",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 24,
                                            ),
                                          ],
                                        );
                                      } else if (snapshot.hasError) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.email_outlined,
                                              color: Colors.deepPurpleAccent,
                                            ),
                                            const SizedBox(
                                              height: 24,
                                            ),
                                            const Icon(
                                              Icons.error_outline,
                                              color: Colors.red,
                                            ),
                                            const SizedBox(
                                              height: 24,
                                            ),
                                            Text(snapshot.error.toString()),
                                            const SizedBox(
                                              height: 24,
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                width: width,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          24.0),
                                                  color: Colors.red,
                                                ),
                                                child: Text(
                                                  "close",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 24,
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.email_outlined,
                                              color: Colors.deepPurpleAccent,
                                            ),
                                            const SizedBox(
                                              height: 24,
                                            ),
                                            const CupertinoActivityIndicator(),
                                            const SizedBox(
                                              height: 24,
                                            ),
                                            Container(
                                              width: width,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(24.0),
                                                color: Colors
                                                    .deepPurpleAccent.shade100,
                                              ),
                                              child: Text(
                                                "Continue",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 24,
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                    future: AuthServices(context)
                                        .signUpwithEmail(
                                            _email.text, _password.text),
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please enter a valid password Length >6'),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter a valid email'),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please agree to terms & condition'),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    child: Text(
                      'Create Account',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column signInProgress(
      double width, bool error, bool isProcess, String s, Object? err, int no) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(s),
        const SizedBox(
          height: 12,
        ),
        isProcess
            ? const CupertinoActivityIndicator()
            : error
                ? const Icon(Icons.error_outline_outlined, color: Colors.red)
                : const SizedBox(
                    child: Icon(Icons.done_rounded, color: Colors.green),
                  ),
        const SizedBox(
          height: 12,
        ),
        Text(
          isProcess
              ? "Signup in process"
              : error
                  ? err.toString()
                  : "Signup Completed",
          style: GoogleFonts.poppins(
            color: const Color(0xFF3c3c3c),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        GestureDetector(
          onTap: () {
            if (error) {
              Navigator.pop(context);
            } else {
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Profile(methodNo: no)));
            }
          },
          child: Container(
            width: width,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.0),
              color: isProcess
                  ? Colors.deepPurpleAccent.shade100
                  : error
                      ? Colors.redAccent
                      : Colors.deepPurpleAccent,
            ),
            child: Text(
              error ? "Close" : "Continue",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(
          height: 24,
        ),
      ],
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // widget is resumed
        break;
      case AppLifecycleState.inactive:
        // widget is inactive
        break;
      case AppLifecycleState.paused:
        // widget is paused
        break;
      case AppLifecycleState.detached:
        // widget is detached
        if (isEmailLogin) {
          isEmailLogin = false;
          if (FirebaseAuth.instance.currentUser != null) {
            FirebaseAuth.instance.currentUser!.delete();
          }
        }
        break;
    }
  }
}
