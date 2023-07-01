import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paurakhi/main.dart';
import 'package:paurakhi/src/app/screens/auth/register/PrivacyPolicyTermsAndConditions/privacy_policy_terms_conditions.dart';
import 'package:paurakhi/src/app/screens/home/presentation/blog/blog_screen.dart';
import 'package:paurakhi/src/app/screens/home/presentation/finance/financeenquiry_screen.dart';
import 'package:paurakhi/src/app/screens/home/presentation/grants/grants_screen.dart';
import 'package:paurakhi/src/app/screens/home/presentation/news/news_screen.dart';
import 'package:paurakhi/src/core/API/AllAPIEndPoint/all_api_endpoint.dart';
import 'package:paurakhi/src/core/API/PrivacyPolicyAndTermsAndConditionsAPI/privacypolicy_termsandconditions.dart';
import 'package:paurakhi/src/core/env/envmodels.dart';

class DrawerRoutes {
  static void blogRoute() {
    Get.to(const BlogScreen());

    scaffoldKey.currentState!.openEndDrawer();
  }

  static void homeRoute(context) {
    Navigator.pop(context);
  }

  static void newsRoute() {
    Get.to(const NewsScreen());

    scaffoldKey.currentState!.openEndDrawer();
  }

  static void grantsRoute() {
    Get.to(const GrantsScreen());

    scaffoldKey.currentState!.openEndDrawer();
  }

  static void categoryRoute() {}
  static void financeRoute() {
    Get.to(const FinanceScreen());

    scaffoldKey.currentState!.openEndDrawer();
  }

  static void privacyPolicy(context) {
    PrivacyPolicyTermsAndConditionsAPI.privacyTermsAPI(true,context:context);
    Get.to(() => const PrivacyPolicyTermsAndConditions(
          isPolicy: true,
        ));
  }

  static void termsAndConditions(context) {
    PrivacyPolicyTermsAndConditionsAPI.privacyTermsAPI(false,context:context);

    Get.to(() => const PrivacyPolicyTermsAndConditions(
          isPolicy: false,
        ));
  }
}
