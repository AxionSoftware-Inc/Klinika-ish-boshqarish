import 'package:flutter_test/flutter_test.dart';
import 'package:ishtaqsimoti/main.dart';

void main() {
  testWidgets('shows clinic task flow', (tester) async {
    await tester.pumpWidget(const ClinicTasksApp());

    expect(find.text('Klinika'), findsOneWidget);
    expect(find.text('Ishlar'), findsAtLeastNWidgets(1));
    expect(find.text('Ish qo‘shish'), findsOneWidget);
    expect(find.text('Bugungi qabul xonalarini tayyorlash'), findsOneWidget);
    expect(find.text('Hisobot'), findsOneWidget);

    await tester.tap(find.text('Bugungi qabul xonalarini tayyorlash'));
    await tester.pumpAndSettle();

    expect(find.text('Ish'), findsOneWidget);
    expect(find.text('Tahrirlash'), findsOneWidget);
    expect(find.textContaining('Qabul xonalarini soat 09:00 gacha tayyorlang'), findsOneWidget);
  });
}
