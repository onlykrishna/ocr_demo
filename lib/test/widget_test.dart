import 'package:flutter_test/flutter_test.dart';

import '../main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const OCRDemoApp());

    // Verify that the app starts and shows the title
    expect(find.text('Flutter OCR Demo'), findsOneWidget);
  });
}