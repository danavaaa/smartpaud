import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartpaud/features/auth/login_page.dart';

void main() {
  testWidgets('LoginPage renders', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));

    expect(find.byType(LoginPage), findsOneWidget);
  });
}
