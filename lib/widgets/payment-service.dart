import 'dart:convert';
import 'package:http/http.dart' as http;

Future createPaymentIntent(
    {required String name,
      required String address,
      required String pin,
      required String city,
      required String state,
      required String country,
      required String currency,
      required String amount}) async {
  final url = Uri.parse('https://api.stripe.com/v1/payment_intents');
  const secretKey =
      "sk_test_51PNX4jH1NQS69RRiDjkV7W43yweXXE9XsmBvXTT3bjseRoYzSvaFlKNaE0bZZIrnlTNYspnyqWGv0ejh4sp1SvlC00m6uWHRBT";
  final body = {
    'amount': amount,
    'currency': currency.toLowerCase(),
    'automatic_payment_methods[enabled]': 'true',
    'description': "Test",
    'shipping[name]': name,
    'shipping[address][line1]': address,
    'shipping[address][postal_code]': pin,
    'shipping[address][city]': city,
    'shipping[address][state]': state,
    'shipping[address][country]': country
  };

  final response = await http.post(url,
      headers: {
        "Authorization": "Bearer $secretKey",
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: body);

  print(body);

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    print(json);
    return json;
  } else {
    print("error in calling payment intent");
  }
}
