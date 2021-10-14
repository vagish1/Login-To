import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_to/screens/login.dart';
import 'package:login_to/services/auth_services.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key, required this.methodNo}) : super(key: key);
  final int methodNo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: methodNo == 0
              ? googleMethod(context)
              : methodNo == 1
                  ? facebookMethod(context)
                  : googleMethod(context),
        ),
      ),
    );
  }

  Container googleMethod(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 36,
          ),
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(
              methodNo == 0
                  ? AuthServices(context).extractPhotoUrl()
                  : "https://images.unsplash.com/photo-1633196931350-201ccf6f624d?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=387&q=80",
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          methodNo == 0
              ? Text(
                  AuthServices(context).extractName(),
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFF3c3c3c),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : FutureBuilder<String?>(
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text("${snapshot.data}");
                    } else {
                      return const Text("Unable to fetch name");
                    }
                  },
                  future: AuthServices(context).goodName(),
                ),
          Text(
            AuthServices(context).extractEmail(),
            style: GoogleFonts.montserrat(
              color: const Color(0xFF3c3c3c),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(
            height: 24,
          ),
          InkWell(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Login()));
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.deepPurpleAccent),
              child: Text(
                "Log out",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ),

          //Text(AuthServices(context).extractPhone()),
          const SizedBox(
            height: 24,
          ),
          ListTile(
            leading: const Icon(Icons.call_outlined),
            title: Text("Phone number", style: GoogleFonts.montserrat()),
            subtitle: Text(AuthServices(context).extractPhone() == null
                ? "Not available not shown by Google"
                : "${AuthServices(context).extractPhone()}"),
          ),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: Text("Email id", style: GoogleFonts.montserrat()),
            subtitle: Text(AuthServices(context).extractEmail().isEmpty
                ? "Not available not shown by Google"
                : AuthServices(context).extractEmail()),
          ),
          ListTile(
            leading: const Icon(Icons.perm_identity_outlined),
            title: Text("Unique id", style: GoogleFonts.montserrat()),
            subtitle: Text(AuthServices(context).extractUid().isEmpty
                ? "Not available not shown by Google"
                : AuthServices(context).extractUid()),
          ),
          ListTile(
            leading: const Icon(Icons.account_box_outlined),
            title: Text("Tenant id", style: GoogleFonts.montserrat()),
            subtitle: Text(AuthServices(context).tenentUid() == null
                ? "Not available not shown by Google"
                : "${AuthServices(context).tenentUid()}"),
          ),
        ],
      ),
    );
  }

  Container facebookMethod(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 36,
          ),
          FutureBuilder<String?>(
            future: AuthServices(context).fbProfile(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                    snapshot.data!,
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
          const SizedBox(
            height: 24,
          ),
          FutureBuilder<String?>(
              future: AuthServices(context).fbName(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data!,
                    style: GoogleFonts.montserrat(
                      color: const Color(0xFF3c3c3c),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                } else {
                  return Text(
                    "N/A",
                    style: GoogleFonts.montserrat(
                      color: const Color(0xFF3c3c3c),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }
              }),
          FutureBuilder<String?>(
              future: AuthServices(context).fbEmail(),
              builder: (context, snapshot) {
                return Text(
                  "Email",
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFF3c3c3c),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }),

          const SizedBox(
            height: 24,
          ),
          InkWell(
            onTap: () {
              FirebaseAuth.instance.signOut();
              if (methodNo == 1) {
                FacebookAuth.i.logOut();
              }
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Login()));
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.deepPurpleAccent),
              child: Text(
                "Log out",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ),

          //Text(AuthServices(context).extractPhone()),
          const SizedBox(
            height: 24,
          ),
          ListTile(
            leading: const Icon(Icons.call_outlined),
            title: Text("Phone number", style: GoogleFonts.montserrat()),
            subtitle: Text(AuthServices(context).extractPhone() == null
                ? "Requires extra privaleges"
                : "${AuthServices(context).extractPhone()}"),
          ),
          ListTile(
            leading: SvgPicture.asset(
              'assets/svg/facebook.svg',
              width: 24,
              height: 24,
            ),
            title: Text("Facebook profile id", style: GoogleFonts.montserrat()),
            subtitle: FutureBuilder<String?>(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text("${snapshot.data}");
                } else {
                  return const Text("Unable to fetch Fb id");
                }
              },
              future: AuthServices(context).fbID(),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.perm_identity_outlined),
            title: Text("Unique id", style: GoogleFonts.montserrat()),
            subtitle: Text(AuthServices(context).extractUid().isEmpty
                ? "Not available not shown by Authenticator"
                : AuthServices(context).extractUid()),
          ),
          ListTile(
            leading: const Icon(Icons.account_box_outlined),
            title: Text("Tenant id", style: GoogleFonts.montserrat()),
            subtitle: Text(AuthServices(context).tenentUid() == null
                ? "Not available not shown by Authenticator"
                : "${AuthServices(context).tenentUid()}"),
          ),
        ],
      ),
    );
  }
}
