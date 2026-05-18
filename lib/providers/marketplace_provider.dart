import 'dart:math';

import 'package:flutter/foundation.dart';

import '../core/constants/app_constants.dart';
import '../core/mock/mock_data.dart';
import '../models/app_user.dart';
import '../models/booking.dart';
import '../models/enums.dart';
import '../models/professional.dart';
import '../models/review.dart';
import '../models/service_item.dart';
import '../models/verification_request.dart';
import '../services/local_storage_service.dart';

class MarketplaceProvider extends ChangeNotifier {
  MarketplaceProvider(this._localStorageService)
    : _professionals = List<Professional>.of(MockData.professionals),
      _services = List<ServiceItem>.of(MockData.services),
      _reviews = List<Review>.of(MockData.reviews),
      _bookings = List<Booking>.of(MockData.bookings),
      _currentUser = MockData.currentUser,
      _verificationRequest = MockData.verificationRequest;

  final LocalStorageService _localStorageService;
  final List<Professional> _professionals;
  final List<ServiceItem> _services;
  final List<Review> _reviews;
  final List<Booking> _bookings;
  final AppUser _currentUser;
  VerificationRequest _verificationRequest;
  final Set<String> _favoriteProfessionalIds = <String>{};

  bool _initialized = false;
  String _searchQuery = '';
  String _selectedCity = 'Todas';
  ServiceCategory? _selectedCategory;
  double _selectedMinRating = 0;
  double _selectedMaxPrice = AppConstants.maxFilterPrice;

  bool get initialized => _initialized;
  AppUser get currentUser => _currentUser;
  String get searchQuery => _searchQuery;
  String get selectedCity => _selectedCity;
  ServiceCategory? get selectedCategory => _selectedCategory;
  double get selectedMinRating => _selectedMinRating;
  double get selectedMaxPrice => _selectedMaxPrice;
  VerificationRequest get verificationRequest => _verificationRequest;

  List<Professional> get professionals => List<Professional>.unmodifiable(
    _professionals,
  );

  List<Professional> get filteredProfessionals {
    final query = _searchQuery.trim().toLowerCase();
    final list = _professionals.where((professional) {
      final averagePrice = averagePriceFor(professional.id);
      final rating = averageRatingFor(professional.id);
      final matchesQuery =
          professional.name.toLowerCase().contains(query) ||
          professional.specialty.toLowerCase().contains(query);
      final matchesCity =
          _selectedCity == 'Todas' || professional.city == _selectedCity;
      final matchesCategory =
          _selectedCategory == null ||
          professional.category == _selectedCategory;
      final matchesRating = rating >= _selectedMinRating;
      final matchesPrice = averagePrice <= _selectedMaxPrice;
      return matchesQuery &&
          matchesCity &&
          matchesCategory &&
          matchesRating &&
          matchesPrice;
    }).toList();

    list.sort((a, b) => averageRatingFor(b.id).compareTo(averageRatingFor(a.id)));
    return list;
  }

  List<Professional> get favoriteProfessionals => _professionals
      .where((professional) => _favoriteProfessionalIds.contains(professional.id))
      .toList(growable: false);

  List<String> get cityOptions {
    final cities = _professionals.map((e) => e.city).toSet().toList()..sort();
    return <String>['Todas', ...cities];
  }

  List<ServiceCategory?> get categoryOptions => <ServiceCategory?>[
    null,
    ...ServiceCategory.values,
  ];

  Professional get loggedProfessional {
    return _professionals.firstWhere(
      (professional) => professional.id == AppConstants.defaultProfessionalId,
      orElse: () => _professionals.first,
    );
  }

  List<ServiceItem> get services => List<ServiceItem>.unmodifiable(_services);
  List<Review> get reviews => List<Review>.unmodifiable(_reviews);
  List<Booking> get bookings => List<Booking>.unmodifiable(_bookings);

  Future<void> initialize() async {
    final favorites = await _localStorageService.getFavoriteProfessionalIds();
    _favoriteProfessionalIds
      ..clear()
      ..addAll(favorites);
    _initialized = true;
    notifyListeners();
  }

  Professional? professionalById(String id) {
    for (final professional in _professionals) {
      if (professional.id == id) {
        return professional;
      }
    }
    return null;
  }

  ServiceItem? serviceById(String id) {
    for (final service in _services) {
      if (service.id == id) {
        return service;
      }
    }
    return null;
  }

  List<ServiceItem> servicesForProfessional(String professionalId) {
    final list = _services
        .where((service) => service.professionalId == professionalId)
        .toList();
    list.sort((a, b) => a.name.compareTo(b.name));
    return list;
  }

  List<ServiceItem> activeServicesForProfessional(String professionalId) {
    return servicesForProfessional(
      professionalId,
    ).where((service) => service.isActive).toList();
  }

  List<Review> reviewsForProfessional(String professionalId) {
    final list = _reviews
        .where((review) => review.professionalId == professionalId)
        .toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  List<Booking> bookingsForProfessional(String professionalId) {
    final list = _bookings
        .where((booking) => booking.professionalId == professionalId)
        .toList();
    list.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return list;
  }

  List<Booking> get customerBookings {
    final list = _bookings
        .where((booking) => booking.customerName == _currentUser.name)
        .toList();
    list.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return list;
  }

  List<Booking> get customerUpcomingBookings => customerBookings
      .where(
        (booking) =>
            booking.status == BookingStatus.pending ||
            booking.status == BookingStatus.confirmed,
      )
      .toList();

  List<Booking> get customerHistory => customerBookings
      .where(
        (booking) =>
            booking.status == BookingStatus.completed ||
            booking.status == BookingStatus.canceled,
      )
      .toList();

  List<Booking> get loggedProfessionalAgenda {
    final now = DateTime.now();
    final list = bookingsForProfessional(loggedProfessional.id)
        .where(
          (booking) =>
              booking.dateTime.isAfter(now) &&
              booking.status != BookingStatus.canceled,
        )
        .toList();
    list.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return list;
  }

  double averageRatingFor(String professionalId) {
    final items = reviewsForProfessional(professionalId);
    if (items.isEmpty) return 0;
    final total = items.fold<double>(0, (sum, review) => sum + review.rating);
    return total / items.length;
  }

  int reviewCountFor(String professionalId) {
    return reviewsForProfessional(professionalId).length;
  }

  double averagePriceFor(String professionalId) {
    final items = activeServicesForProfessional(professionalId);
    if (items.isEmpty) return 0;
    final total = items.fold<double>(0, (sum, service) => sum + service.price);
    return total / items.length;
  }

  double get simulatedEarnings {
    return bookingsForProfessional(loggedProfessional.id)
        .where((booking) => booking.status == BookingStatus.completed)
        .fold<double>(0, (sum, booking) => sum + booking.price);
  }

  int get totalUsers => 128;
  int get totalProfessionals => _professionals.length;
  int get totalBookings => _bookings.length;
  int get totalActiveServices => _services.where((service) => service.isActive).length;

  int get pendingBookingsCount =>
      _bookings.where((booking) => booking.status == BookingStatus.pending).length;

  int get completedBookingsCount =>
      _bookings
          .where((booking) => booking.status == BookingStatus.completed)
          .length;

  bool isFavorite(String professionalId) =>
      _favoriteProfessionalIds.contains(professionalId);

  Future<void> toggleFavorite(String professionalId) async {
    if (_favoriteProfessionalIds.contains(professionalId)) {
      _favoriteProfessionalIds.remove(professionalId);
    } else {
      _favoriteProfessionalIds.add(professionalId);
    }
    await _localStorageService.setFavoriteProfessionalIds(
      _favoriteProfessionalIds.toList(growable: false),
    );
    notifyListeners();
  }

  void updateSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void updateCityFilter(String city) {
    _selectedCity = city;
    notifyListeners();
  }

  void updateCategoryFilter(ServiceCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void updateMinRating(double minRating) {
    _selectedMinRating = minRating;
    notifyListeners();
  }

  void updateMaxPrice(double maxPrice) {
    _selectedMaxPrice = maxPrice;
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedCity = 'Todas';
    _selectedCategory = null;
    _selectedMinRating = 0;
    _selectedMaxPrice = AppConstants.maxFilterPrice;
    notifyListeners();
  }

  void createService({
    required String professionalId,
    required String name,
    required String description,
    required double price,
    required int durationMinutes,
  }) {
    _services.add(
      ServiceItem(
        id: 'srv-${DateTime.now().microsecondsSinceEpoch}',
        professionalId: professionalId,
        name: name,
        description: description,
        price: price,
        durationMinutes: durationMinutes,
      ),
    );
    notifyListeners();
  }

  void updateService(ServiceItem service) {
    final index = _services.indexWhere((item) => item.id == service.id);
    if (index == -1) return;
    _services[index] = service;
    notifyListeners();
  }

  void deleteService(String serviceId) {
    _services.removeWhere((service) => service.id == serviceId);
    notifyListeners();
  }

  void toggleServiceStatus(String serviceId) {
    final index = _services.indexWhere((service) => service.id == serviceId);
    if (index == -1) return;
    final existing = _services[index];
    _services[index] = existing.copyWith(isActive: !existing.isActive);
    notifyListeners();
  }

  void createBooking({
    required Professional professional,
    required ServiceItem service,
    required DateTime dateTime,
  }) {
    _bookings.add(
      Booking(
        id: 'bk-${DateTime.now().microsecondsSinceEpoch}',
        professionalId: professional.id,
        professionalName: professional.name,
        customerName: _currentUser.name,
        serviceId: service.id,
        serviceName: service.name,
        dateTime: dateTime,
        status: BookingStatus.pending,
        price: service.price,
      ),
    );
    notifyListeners();
  }

  void updateBookingStatus(String bookingId, BookingStatus status) {
    final index = _bookings.indexWhere((booking) => booking.id == bookingId);
    if (index == -1) return;
    _bookings[index] = _bookings[index].copyWith(status: status);
    notifyListeners();
  }

  void cancelBooking(String bookingId) {
    updateBookingStatus(bookingId, BookingStatus.canceled);
  }

  void addReview({
    required String professionalId,
    required double rating,
    required String comment,
    String? userName,
  }) {
    _reviews.add(
      Review(
        id: 'rev-${DateTime.now().microsecondsSinceEpoch}',
        professionalId: professionalId,
        userName: userName ?? _currentUser.name,
        rating: rating,
        comment: comment,
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void uploadDocument() {
    _verificationRequest = _verificationRequest.copyWith(
      documentUploaded: true,
      status: VerificationStatus.pending,
      lastUpdated: DateTime.now(),
    );
    notifyListeners();
  }

  void captureSelfie() {
    _verificationRequest = _verificationRequest.copyWith(
      selfieCaptured: true,
      status: VerificationStatus.pending,
      lastUpdated: DateTime.now(),
    );
    notifyListeners();
  }

  Future<void> submitVerification() async {
    if (!_verificationRequest.documentUploaded ||
        !_verificationRequest.selfieCaptured) {
      return;
    }
    final random = Random();
    await Future<void>.delayed(const Duration(seconds: 2));
    final nextStatus = VerificationStatus.values[random.nextInt(3)];
    _verificationRequest = _verificationRequest.copyWith(
      status: nextStatus,
      lastUpdated: DateTime.now(),
    );
    notifyListeners();
  }

  void resetVerificationFlow() {
    _verificationRequest = const VerificationRequest(
      documentUploaded: false,
      selfieCaptured: false,
      status: VerificationStatus.pending,
    );
    notifyListeners();
  }
}
