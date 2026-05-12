import 'package:flutter_test/flutter_test.dart';
import 'package:trackly/main.dart';

void main() {
  testWidgets('TRACKLY app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TracklyApp());
    expect(find.byType(TracklyApp), findsOneWidget);
  });
}
