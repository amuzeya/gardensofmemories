// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:ysl_beauty_experience/main.dart';

void main() {
  testWidgets('YSL Beauty theme guide test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const YSLBeautyApp());

    // Verify that the theme guide loads with the correct title.
    expect(find.text('YSL BEAUTY THEME GUIDE'), findsOneWidget);
    
    // Verify that typography section is present.
    expect(find.text('TYPOGRAPHY'), findsOneWidget);
    
    // Verify that colors section is present.
    expect(find.text('COLORS'), findsOneWidget);
    
    // Verify some key typography examples are present.
    expect(find.text('AppText.heroDisplay'), findsOneWidget);
    expect(find.text('AppText.titleLarge'), findsOneWidget);
    
    // Verify some key color examples are present.
    expect(find.text('AppColors.yslBlack'), findsOneWidget);
    expect(find.text('AppColors.yslWhite'), findsOneWidget);
    expect(find.text('AppColors.yslGold'), findsOneWidget);
  });
}
