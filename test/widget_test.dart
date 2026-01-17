import 'package:flutter_test/flutter_test.dart';
import 'package:smartbooking/main.dart';

void main() {
  testWidgets('App builds', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartBookingApp());
    expect(find.byType(SmartBookingApp), findsOneWidget);
  });
}
