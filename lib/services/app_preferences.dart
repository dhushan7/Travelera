import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const String onboardingKey = "onboarding_completed";

  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(onboardingKey) ?? false);
  }

  static Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(onboardingKey, true);
  }
}