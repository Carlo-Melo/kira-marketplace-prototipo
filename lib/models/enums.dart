enum ServiceCategory { hair, nails, makeup, esthetics, barber, massage }

extension ServiceCategoryX on ServiceCategory {
  String get label {
    switch (this) {
      case ServiceCategory.hair:
        return 'Cabelo';
      case ServiceCategory.nails:
        return 'Unhas';
      case ServiceCategory.makeup:
        return 'Maquiagem';
      case ServiceCategory.esthetics:
        return 'Estetica';
      case ServiceCategory.barber:
        return 'Barbearia';
      case ServiceCategory.massage:
        return 'Massagem';
    }
  }
}

enum BookingStatus { pending, confirmed, completed, canceled }

extension BookingStatusX on BookingStatus {
  String get label {
    switch (this) {
      case BookingStatus.pending:
        return 'Pendente';
      case BookingStatus.confirmed:
        return 'Confirmado';
      case BookingStatus.completed:
        return 'Concluido';
      case BookingStatus.canceled:
        return 'Cancelado';
    }
  }
}

enum VerificationStatus { approved, pending, rejected }

extension VerificationStatusX on VerificationStatus {
  String get label {
    switch (this) {
      case VerificationStatus.approved:
        return 'APPROVED';
      case VerificationStatus.pending:
        return 'PENDING';
      case VerificationStatus.rejected:
        return 'REJECTED';
    }
  }
}
