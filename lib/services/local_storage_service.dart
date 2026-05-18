import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _onboardingKey = 'kira.onboarding.completed';
  static const _favoritesKey = 'kira.favorites.professionals';

  Future<bool> getOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, completed);
  }

  Future<List<String>> getFavoriteProfessionalIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? <String>[];
  }

  Future<void> setFavoriteProfessionalIds(List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, ids);
  }
}
