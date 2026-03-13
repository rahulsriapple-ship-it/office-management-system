import 'package:flutter_test/flutter_test.dart';
import 'package:office_admin/app.dart';

void main() {
  testWidgets('office admin app renders login screen', (tester) async {
    await tester.pumpWidget(const OfficeAdminApp());

    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Forgot password?'), findsOneWidget);
  });
}
