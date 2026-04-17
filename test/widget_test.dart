import 'package:flutter_test/flutter_test.dart';

import 'package:editorial_estate/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const EditorialEstateApp());
    expect(find.byType(EditorialEstateApp), findsOneWidget);
  });
}
