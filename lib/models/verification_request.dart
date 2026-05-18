import 'enums.dart';

class VerificationRequest {
  const VerificationRequest({
    this.documentUploaded = false,
    this.selfieCaptured = false,
    this.status = VerificationStatus.pending,
    this.lastUpdated,
  });

  final bool documentUploaded;
  final bool selfieCaptured;
  final VerificationStatus status;
  final DateTime? lastUpdated;

  VerificationRequest copyWith({
    bool? documentUploaded,
    bool? selfieCaptured,
    VerificationStatus? status,
    DateTime? lastUpdated,
  }) {
    return VerificationRequest(
      documentUploaded: documentUploaded ?? this.documentUploaded,
      selfieCaptured: selfieCaptured ?? this.selfieCaptured,
      status: status ?? this.status,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
