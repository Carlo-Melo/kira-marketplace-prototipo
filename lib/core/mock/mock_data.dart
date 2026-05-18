import '../../models/app_user.dart';
import '../../models/booking.dart';
import '../../models/enums.dart';
import '../../models/professional.dart';
import '../../models/review.dart';
import '../../models/service_item.dart';
import '../../models/verification_request.dart';

class MockData {
  static const currentUser = AppUser(
    id: 'user-1',
    name: 'Ana Beatriz Souza',
    email: 'ana.souza@email.com',
    phone: '(11) 98888-1001',
    photoUrl: 'https://i.pravatar.cc/300?img=32',
  );

  static final professionals = <Professional>[
    const Professional(
      id: 'pro-1',
      name: 'Camila Rocha',
      specialty: 'Colorista e Hair Stylist',
      city: 'Sao Paulo',
      imageUrl: 'https://i.pravatar.cc/400?img=47',
      bio:
          'Especialista em coloracao personalizada, corte feminino e cronograma capilar para cabelos danificados.',
      category: ServiceCategory.hair,
    ),
    const Professional(
      id: 'pro-2',
      name: 'Marina Alves',
      specialty: 'Nail Designer',
      city: 'Campinas',
      imageUrl: 'https://i.pravatar.cc/400?img=35',
      bio:
          'Atendimento premium em unhas em gel, blindagem e nail art minimalista para eventos e rotina.',
      category: ServiceCategory.nails,
    ),
    const Professional(
      id: 'pro-3',
      name: 'Renata Lima',
      specialty: 'Makeup Artist',
      city: 'Sao Paulo',
      imageUrl: 'https://i.pravatar.cc/400?img=12',
      bio:
          'Maquiagem social, noivas e producoes editoriais com tecnicas de acabamento de alta duracao.',
      category: ServiceCategory.makeup,
    ),
    const Professional(
      id: 'pro-4',
      name: 'Joao Nunes',
      specialty: 'Barbeiro e Visagista',
      city: 'Santos',
      imageUrl: 'https://i.pravatar.cc/400?img=14',
      bio:
          'Cortes modernos, degradê, design de barba e consultoria de imagem para o dia a dia.',
      category: ServiceCategory.barber,
    ),
    const Professional(
      id: 'pro-5',
      name: 'Viviane Castro',
      specialty: 'Esteticista Facial',
      city: 'Sao Paulo',
      imageUrl: 'https://i.pravatar.cc/400?img=45',
      bio:
          'Procedimentos faciais nao invasivos, limpeza profunda, hidratacao e rejuvenescimento da pele.',
      category: ServiceCategory.esthetics,
    ),
    const Professional(
      id: 'pro-6',
      name: 'Talita Mendes',
      specialty: 'Massoterapeuta',
      city: 'Guarulhos',
      imageUrl: 'https://i.pravatar.cc/400?img=5',
      bio:
          'Massagens relaxantes e terapeuticas para alivio de tensao, estresse e dores musculares.',
      category: ServiceCategory.massage,
    ),
  ];

  static final services = <ServiceItem>[
    const ServiceItem(
      id: 'srv-1',
      professionalId: 'pro-1',
      name: 'Corte Feminino',
      description: 'Corte com finalizacao e orientacao de rotina.',
      price: 95,
      durationMinutes: 60,
    ),
    const ServiceItem(
      id: 'srv-2',
      professionalId: 'pro-1',
      name: 'Luzes + Tonalizacao',
      description: 'Transformacao de cor com tratamento pos-procedimento.',
      price: 280,
      durationMinutes: 180,
    ),
    const ServiceItem(
      id: 'srv-3',
      professionalId: 'pro-2',
      name: 'Unha em Gel',
      description: 'Alongamento com acabamento natural.',
      price: 140,
      durationMinutes: 110,
    ),
    const ServiceItem(
      id: 'srv-4',
      professionalId: 'pro-2',
      name: 'Manicure Premium',
      description: 'Cutilagem russa e esmaltação em gel.',
      price: 85,
      durationMinutes: 70,
    ),
    const ServiceItem(
      id: 'srv-5',
      professionalId: 'pro-3',
      name: 'Maquiagem Social',
      description: 'Pele blindada para festas e eventos.',
      price: 220,
      durationMinutes: 90,
    ),
    const ServiceItem(
      id: 'srv-6',
      professionalId: 'pro-3',
      name: 'Pacote Noiva',
      description: 'Teste + maquiagem no dia + retoque express.',
      price: 680,
      durationMinutes: 220,
    ),
    const ServiceItem(
      id: 'srv-7',
      professionalId: 'pro-4',
      name: 'Corte Degrade',
      description: 'Corte com tecnica de transicao suave.',
      price: 70,
      durationMinutes: 45,
    ),
    const ServiceItem(
      id: 'srv-8',
      professionalId: 'pro-4',
      name: 'Barba Premium',
      description: 'Toalha quente, desenho e finalizacao.',
      price: 65,
      durationMinutes: 40,
    ),
    const ServiceItem(
      id: 'srv-9',
      professionalId: 'pro-5',
      name: 'Limpeza de Pele',
      description: 'Higienizacao profunda e mascara calmante.',
      price: 180,
      durationMinutes: 80,
    ),
    const ServiceItem(
      id: 'srv-10',
      professionalId: 'pro-5',
      name: 'Peeling de Diamante',
      description: 'Esfoliacao controlada e revitalizacao.',
      price: 230,
      durationMinutes: 75,
    ),
    const ServiceItem(
      id: 'srv-11',
      professionalId: 'pro-6',
      name: 'Massagem Relaxante',
      description: 'Sessao completa para alivio de tensao.',
      price: 160,
      durationMinutes: 60,
    ),
    const ServiceItem(
      id: 'srv-12',
      professionalId: 'pro-6',
      name: 'Drenagem Linfatica',
      description: 'Tecnica manual para retencao de liquidos.',
      price: 190,
      durationMinutes: 70,
      isActive: false,
    ),
  ];

  static final reviews = <Review>[
    Review(
      id: 'rev-1',
      professionalId: 'pro-1',
      userName: 'Larissa M.',
      rating: 4.8,
      comment: 'Atendimento impecavel e resultado muito natural.',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    Review(
      id: 'rev-2',
      professionalId: 'pro-1',
      userName: 'Flavia R.',
      rating: 5.0,
      comment: 'Melhor coloracao que ja fiz.',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    Review(
      id: 'rev-3',
      professionalId: 'pro-2',
      userName: 'Nina A.',
      rating: 4.7,
      comment: 'Unhas duraram bastante, recomendo muito.',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Review(
      id: 'rev-4',
      professionalId: 'pro-3',
      userName: 'Bruna K.',
      rating: 4.9,
      comment: 'Maquiagem linda e resistente.',
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
    ),
    Review(
      id: 'rev-5',
      professionalId: 'pro-4',
      userName: 'Carlos P.',
      rating: 4.5,
      comment: 'Corte preciso e ambiente bem organizado.',
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
    ),
    Review(
      id: 'rev-6',
      professionalId: 'pro-5',
      userName: 'Paula F.',
      rating: 4.9,
      comment: 'Minha pele ficou renovada.',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  static final bookings = <Booking>[
    Booking(
      id: 'bk-1',
      professionalId: 'pro-1',
      professionalName: 'Camila Rocha',
      customerName: 'Ana Beatriz Souza',
      serviceId: 'srv-1',
      serviceName: 'Corte Feminino',
      dateTime: DateTime.now().add(const Duration(days: 2, hours: 3)),
      status: BookingStatus.pending,
      price: 95,
    ),
    Booking(
      id: 'bk-2',
      professionalId: 'pro-3',
      professionalName: 'Renata Lima',
      customerName: 'Ana Beatriz Souza',
      serviceId: 'srv-5',
      serviceName: 'Maquiagem Social',
      dateTime: DateTime.now().subtract(const Duration(days: 12)),
      status: BookingStatus.completed,
      price: 220,
    ),
    Booking(
      id: 'bk-3',
      professionalId: 'pro-1',
      professionalName: 'Camila Rocha',
      customerName: 'Juliana S.',
      serviceId: 'srv-2',
      serviceName: 'Luzes + Tonalizacao',
      dateTime: DateTime.now().add(const Duration(days: 1, hours: 5)),
      status: BookingStatus.confirmed,
      price: 280,
    ),
    Booking(
      id: 'bk-4',
      professionalId: 'pro-1',
      professionalName: 'Camila Rocha',
      customerName: 'Tais M.',
      serviceId: 'srv-1',
      serviceName: 'Corte Feminino',
      dateTime: DateTime.now().subtract(const Duration(days: 3)),
      status: BookingStatus.completed,
      price: 95,
    ),
    Booking(
      id: 'bk-5',
      professionalId: 'pro-2',
      professionalName: 'Marina Alves',
      customerName: 'Ana Beatriz Souza',
      serviceId: 'srv-4',
      serviceName: 'Manicure Premium',
      dateTime: DateTime.now().subtract(const Duration(days: 1)),
      status: BookingStatus.canceled,
      price: 85,
    ),
  ];

  static const verificationRequest = VerificationRequest(
    documentUploaded: false,
    selfieCaptured: false,
    status: VerificationStatus.pending,
  );
}
