import 'package:flutter/foundation.dart';

import '../services/local_storage_service.dart';

class AppProvider extends ChangeNotifier {
  AppProvider(this._localStorageService);

  final LocalStorageService _localStorageService;

  bool _initialized = false;
  bool _onboardingCompleted = false;

  bool get initialized => _initialized;
  bool get onboardingCompleted => _onboardingCompleted;

  Future<void> initialize() async {
    _onboardingCompleted = await _localStorageService.getOnboardingCompleted();
    _initialized = true;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _onboardingCompleted = true;
    await _localStorageService.setOnboardingCompleted(true);
    notifyListeners();
  }
}
