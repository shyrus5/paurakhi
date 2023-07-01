import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:paurakhi/src/core/API/AllAPIEndPoint/all_api_endpoint.dart';
import 'package:paurakhi/src/core/dialogs/auth/alldialogs.dart';
import 'package:paurakhi/src/core/env/envmodels.dart';
import 'package:http/http.dart' as http;

class PrivacyPolicyTermsAndConditionsAPI {
  static String body = "";
  static void privacyTermsAPI(bool isPolicy, {context}) async {
    String policyUrl = "${Environment.apiUrl}${AllAPIEndPoint.policy}";
    String termsUrl =
        "${Environment.apiUrl}${AllAPIEndPoint.termsAndCondition}";
    try {
      var response =
          await http.get(isPolicy ? Uri.parse(policyUrl) : Uri.parse(termsUrl));

      var statusCode = response.statusCode;
      print(response.body);
      if (statusCode == 200) {
        var result = json.decode(response.body);
        var message = result["data"];
        body = message;
        debugPrint(response.body);
      } else {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          UserDialogs.internalServerError(context);
        });
      }
    } catch (e) {
      debugPrint("$e");
    }
  }
}
