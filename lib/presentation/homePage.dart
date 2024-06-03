import 'dart:async';
import 'package:chat_stripe_app/presentation/chatPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../widgets/payment-service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Users"),
        actions: [
          IconButton(
              onPressed: () async {
                await GoogleSignIn().signOut();
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('emailId',
                isNotEqualTo: FirebaseAuth.instance.currentUser?.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot doc = snapshot.data!.docs[index];
                Map<String, dynamic>? userMap =
                    doc.data() as Map<String, dynamic>?;
                return ListTile(
                  title: Text(doc['nickname']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(doc['emailId']),
                      Row(
                        children: [
                          Text("Amount: ${doc['amount']}"),
                          TextButton(
                              onPressed: () async {
                                await initPaymentSheet(doc['nickname']);

                                try {
                                  await Stripe.instance.presentPaymentSheet();

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                      "Payment Done",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.green,
                                  ));

                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(doc['id'])
                                      .update({'amount': doc['amount'] + 500});
                                  setState(() {});
                                } catch (e) {
                                  print("payment sheet failed");
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                      "Payment Failed",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.redAccent,
                                  ));
                                }
                              },
                              child: const Text("Add Amount"))
                        ],
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.chat),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChatPage(
                          map: userMap!,
                        ),
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  color: Colors.grey.shade300,
                );
              },
            );
          } else {
            return const Center(child: Text("No data found"));
          }
        },
      ),
    );
  }

  Future<void> initPaymentSheet(String name) async {
    try {
      final data = await createPaymentIntent(
          amount: (int.parse("500") * 100).toString(),
          currency: "USD",
          name: name,
          address: "near by somnath temple",
          pin: "2323432",
          city: "Kadi",
          state: "Gujrat",
          country: "India");
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: false,
          merchantDisplayName: 'Test Merchant',
          paymentIntentClientSecret: data['client_secret'],
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['id'],
          style: ThemeMode.light,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }
}
