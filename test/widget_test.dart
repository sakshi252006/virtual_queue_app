import 'package:flutter_test/flutter_test.dart';
import 'package:virtual_queue_app/main.dart';

void main() {
  testWidgets('Virtual Queue app test', (WidgetTester tester) async {
    await tester.pumpWidget(const VirtualQueueApp());

    expect(find.text('Virtual Queue'), findsOneWidget);
  });
}
