import 'package:chat_stripe_app/core/utils/common.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../widgets/myButton.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool _isObscure = true;
  bool _isObscureConfirm = true;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

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
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Register New User"),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 70,
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(
                        fontFamily: "GillSansRegular",
                        fontSize: 12,
                        color: Colors.black),
                  ),
                  InkWell(
                    child: const Text(
                      " Click here to Login",
                      style: TextStyle(
                          fontFamily: "GillSansRegular",
                          fontSize: 12,
                          color: Colors.blue),
                    ),
                    onTap: () {
                      Get.back();
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
                _firstNameWidget().vp(15),
                _emailWidget().bp(15),
                _passwordWidget().bp(15),
                _confirmPasswordWidget().bp(40),
                Center(child: MyButton(onTap: registerAction, title: "Register"))
                    .bp(40),
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

  Widget _firstNameWidget() {
    return TextFormField(
        controller: nameController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter a user name.";
          } else if (value.length < 3) {
            return "Please enter a valid user name.";
          } else if (value.length > 50) {
            return "Maximum 50 characters allowed";
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textInputAction: TextInputAction.next, // Hides the keyboard.
        // style: Theme.of(context).textTheme.subtitle1,
        decoration: const InputDecoration(
          labelText: "Name",
          isDense: false,
        ));
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
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              }),
          labelText: "Password",
        ));
  }

  Widget _confirmPasswordWidget() {
    return TextFormField(
        controller: confirmPasswordController,
        obscureText: _isObscureConfirm,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textInputAction: TextInputAction.done,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter a password.";
          } else if (value.length > 16) {
            return "Maximum 16 characters allowed";
          } else if (value.length < 6) {
            return "Password must be have at least 6 characters";
          } else if (value != passwordController.text) {
            return "The confirm password must be same as password";
          }
          return null;
        },
        style: Theme.of(context).textTheme.titleMedium,
        decoration: InputDecoration(
          isDense: false,
          filled: true,
          errorMaxLines: 2,
          fillColor: Colors.white,
          suffixIcon: IconButton(
              icon: Icon(
                _isObscureConfirm ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _isObscureConfirm = !_isObscureConfirm;
                });
              }),
          labelText: "Confirm Password",
        ));
  }

  Future<dynamic> registerAction() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        UserCredential result =  await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        if(result.additionalUserInfo?.isNewUser == true){

          await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
          FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .set({
            'nickname': nameController.text,
            'emailId': FirebaseAuth.instance.currentUser?.email,
            'id': FirebaseAuth.instance.currentUser?.uid,
            'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
            'userStatus': 0,
            'amount': 0,
            'chattingWith': null
          });
          Get.back();
        }
      } on FirebaseAuthException catch (e) {
        if(e.code == "invalid-credential"){
          _handleClickMe("invalid-credential");
        }else{
          _handleClickMe(e.code);
        }
      }
    }
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
                        backgroundColor: Colors.blue,
                      ),
                      child: Text(
                        "Ok",
                        style: Theme.of(context)
                            .textTheme
                            .apply(bodyColor: Colors.white)
                            .titleMedium,
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
