import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:paurakhi/src/core/API/PrivacyPolicyAndTermsAndConditionsAPI/privacypolicy_termsandconditions.dart';
import 'package:paurakhi/src/core/themes/appstyles.dart';

class PrivacyPolicyTermsAndConditions extends StatelessWidget {
  final bool isPolicy;
  const PrivacyPolicyTermsAndConditions({super.key, required this.isPolicy});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(191, 80, 186, 83),
        title: isPolicy
            ? Text(
                "Terms and Conditions",
                style: AppStyles.text24PxMedium,
              )
            : Text(
                "Privacy Policy",
                style: AppStyles.text24PxMedium,
              ),
      ),
      body: Html(
        data: PrivacyPolicyTermsAndConditionsAPI.body,
        style: {
          'body': Style(
            fontSize: FontSize.medium,
            fontWeight: FontWeight.normal,
          ),
        },
      ),
    );
  }
}
