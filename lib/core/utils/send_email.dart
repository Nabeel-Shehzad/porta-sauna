import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:portasauna/core/constants/admin_const.dart';
import 'package:portasauna/core/constants/app_secrets.dart';

Future<bool> sendEmail(
    {required toEmail, required emailText, required subject}) async {
  try {
    String username = AppSecrets.mailJetPublicKey; //public key
    String password = AppSecrets.mailJetPrivateKey; //private or secret key
    String basicAuth =
        'Basic ${base64.encode(utf8.encode('$username:$password'))}';
    var headers = {'authorization': basicAuth};

    var body = {
      "Messages": [
        {
          "From": {"Email": AdminConst.adminEmail, "Name": "PortaSauna"},
          "To": [
            {"Email": toEmail, "Name": "PortaSauna user"}
          ],
          "Subject": subject,
          "TextPart": emailText
        }
      ]
    };

    await http.post(
        Uri.parse(
          'https://api.mailjet.com/v3.1/send',
        ),
        headers: headers,
        body: jsonEncode(body));

    return true;
  } catch (e) {
    print(e);
    Future.error('Failed to send email');
    return false;
  }
}
