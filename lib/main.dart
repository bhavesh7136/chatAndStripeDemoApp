
import 'package:chat_stripe_app/presentation/authPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'themes/app_theme.dart';

final GlobalKey<NavigatorState> navigatorKey =
GlobalKey<NavigatorState>(debugLabel: "navigator");

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Stripe.publishableKey = "pk_test_51PNX4jH1NQS69RRiWqGOYRbeTZFTCqJ45p7u5618mSAsZ87fjchyXx1wsFoJLgAGDtJnAE2kw4VUUTA74sKOWHWE00NjuJJVOB";
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: GetMaterialApp(
        title: 'Chat App',
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: MyAppTheme.lightTheme,
        home: const AuthPage(),
      ),
    );
  }
}
