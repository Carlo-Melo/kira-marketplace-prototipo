import 'enums.dart';

class Booking {
  const Booking({
    required this.id,
    required this.professionalId,
    required this.professionalName,
    required this.customerName,
    required this.serviceId,
    required this.serviceName,
    required this.dateTime,
    required this.status,
    required this.price,
  });

  final String id;
  final String professionalId;
  final String professionalName;
  final String customerName;
  final String serviceId;
  final String serviceName;
  final DateTime dateTime;
  final BookingStatus status;
  final double price;

  Booking copyWith({
    String? id,
    String? professionalId,
    String? professionalName,
    String? customerName,
    String? serviceId,
    String? serviceName,
    DateTime? dateTime,
    BookingStatus? status,
    double? price,
  }) {
    return Booking(
      id: id ?? this.id,
      professionalId: professionalId ?? this.professionalId,
      professionalName: professionalName ?? this.professionalName,
      customerName: customerName ?? this.customerName,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
      price: price ?? this.price,
    );
  }
}
