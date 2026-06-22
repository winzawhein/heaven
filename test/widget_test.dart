import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heaven/main.dart';

void main() {
  testWidgets('App launches correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: HeavenApp(),
      ),
    );

    expect(find.text('Perfect Home'), findsOneWidget);
  });
}
