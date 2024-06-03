import 'package:chat_stripe_app/core/utils/common.dart';
import 'package:chat_stripe_app/presentation/registrationPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../widgets/myButton.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 50,
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "New User?",
                    style: TextStyle(
                        fontFamily: "GillSansRegular",
                        fontSize: 12,
                        color: Colors.black),
                  ),
                  InkWell(
                    child: const Text(
                      " Signup",
                      style: TextStyle(
                          fontFamily: "GillSansRegular",
                          fontSize: 12,
                          color: Colors.blue),
                    ),
                    onTap: () {
                      Get.to(const RegistrationPage());
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // SizedBox(height: 0.01.sh,),
                const Text(
                  "Login",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "SFProBold",
                      fontSize: 28),
                ).vp(100),

                _emailWidget().bp(20),
                _passwordWidget().bp(40),
                Center(
                    child: MyButton(
                  onTap: loginAction,
                  title: "Login",
                )).bp(40),

                Row(children: <Widget>[
                  Expanded(
                    child: Divider(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  const SizedBox(width: 10.5),
                  Text(
                    "OR",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(width: 10.5),
                  Expanded(
                    child: Divider(
                      color: Colors.grey.shade300,
                    ),
                  ),
                ]).bp(30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Image.asset(
                        'assets/images/Google.png',
                        height: 40,
                        width: 40,
                      ),
                      // splashColor: Colors.grey,
                      onPressed: () async {
                        GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
                        GoogleSignInAuthentication gAuth = await gUser!.authentication;
                       final credential = GoogleAuthProvider.credential(accessToken: gAuth.accessToken,idToken: gAuth.idToken);
                       await FirebaseAuth.instance.signInWithCredential(credential);
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser?.uid)
                            .set({
                          'nickname': FirebaseAuth.instance.currentUser?.displayName,
                          'emailId': FirebaseAuth.instance.currentUser?.email,
                          'id': FirebaseAuth.instance.currentUser?.uid,
                          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
                          'userStatus': 0,
                          'amount': 0,
                          'chattingWith': null
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> loginAction() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);

      } on FirebaseAuthException catch (e) {
       if(e.code == "invalid-credential"){
          _handleClickMe("invalid-credential");
        }else{
         _handleClickMe(e.code);
       }
      }
    }
  }

  Widget _emailWidget() {
    return TextFormField(
        controller: emailController,
        validator: (value) {
          String pattern = r"[a-zA-Z0-9\+\.\_\%\-\+]{1,256}\@[a-zA-Z0-9]"
              r"[a-zA-Z0-9\-]{0,64}(\.[a-zA-Z0-9][a-zA-Z0-9\-]{0,25})+";
          RegExp regex = RegExp(pattern);
          if (value == null || value.isEmpty) {
            return "Please enter a email.";
          } else if (!regex.hasMatch(value)) {
            return "Please enter a valid email id.";
          } else if (value.length > 64) {
            return "Maximum 64 characters allowed";
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.emailAddress,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textInputAction: TextInputAction.next, // Hides the keyboard.
        // style: Theme.of(context).textTheme.subtitle1,
        onChanged: (value) {},
        decoration: const InputDecoration(
          isDense: false,
          counterText: '',
          labelText: "Email",
        ));
  }

  Widget _passwordWidget() {
    return TextFormField(
        controller: passwordController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter a password.";
          } else if (value.length > 16) {
            return "Maximum 16 characters allowed";
          } else if (value.length < 6) {
            return "Password must be have at least 6 characters";
          }
          return null;
        },
        obscureText: _isObscure,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textInputAction: TextInputAction.done, // Hides the keyboard.
        // style: Theme.of(context).textTheme.subtitle1,
        onChanged: (value) {},
        decoration: InputDecoration(
          isDense: false,
          errorMaxLines: 2,
          suffixIcon: IconButton(
              icon: Icon(
                _isObscure ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              }),
          labelText: "Password",
        ));
  }

  Future<bool?> _handleClickMe(String content) async {
    var r = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24.0, 15.0, 24.0, 15),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  content,
                  style: const TextStyle(
                      fontFamily: "SFProRegular",
                      fontSize: 18,
                      color: Colors.black),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      child: const Text(
                        "Ok",style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        Navigator.pop(context, true);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
    return r;
  }
}
