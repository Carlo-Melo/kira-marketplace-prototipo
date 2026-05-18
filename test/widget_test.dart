import 'package:flutter_test/flutter_test.dart';

import 'package:prototipo_marketplace/main.dart';

void main() {
  testWidgets('renders splash with Kira brand', (tester) async {
    await tester.pumpWidget(const KiraApp());

    expect(find.text('Kira Marketplace'), findsOneWidget);
    expect(find.text('Beleza sob demanda'), findsOneWidget);
  });
}
