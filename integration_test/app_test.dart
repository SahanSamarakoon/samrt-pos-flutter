import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:smart_pos/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Integration Test - Auth & Tabs Screens', () {
    testWidgets('Auth Screen UI/Navigation and Tabs Screen UI',
        (WidgetTester tester) async {
      //Testing Auth Screen
      final Finder signInEmailField = find.byKey(Key('signInEmailField'));
      final Finder signInPasswordField = find.byKey(Key('signInPasswordField'));
      final Finder signInSaveButton = find.byKey(Key('signInSaveButton'));
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      print("Auth Screen Loaded");
      expect(find.text('Smart POS'), findsOneWidget);
      expect(signInEmailField, findsOneWidget);
      expect(signInPasswordField, findsOneWidget);
      expect(signInSaveButton, findsOneWidget);
      print("Components of Auth Screen Loaded Correctly");

      await tester.tap(find.byKey(Key('signInEmailField')));
      await tester.enterText(signInEmailField, "test@test.com");
      print("Entered Email");

      await tester.tap(signInPasswordField);
      await tester.enterText(signInPasswordField, "Test123");
      print("Entered Password");

      await tester.tap(signInSaveButton);
      print("Sign In button tapped");

      //Testing Tabs Screen
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byKey(Key('bottom')), findsOneWidget);
      final Finder dashboardIcon = find.byKey(Key('dashboardIcon'));
      final Finder inventoryIcon = find.byKey(Key('inventoryIcon'));
      final Finder shopsIcon = find.byKey(Key('shopsIcon'));
      expect(dashboardIcon, findsOneWidget);
      expect(inventoryIcon, findsOneWidget);
      expect(shopsIcon, findsOneWidget);
      print("Components of Tabs Screen Loaded Correctly");

      await tester.tap(inventoryIcon);
      await tester.pumpAndSettle(Duration(seconds: 3));
      print("Navigated to Inventory Screen Correctly");
      await tester.tap(shopsIcon);
      await tester.pumpAndSettle(Duration(seconds: 1));
      print("Navigated to Shops Screen Correctly");
    });
  });

  group('Integration Test - Dashboard Screen', () {
    testWidgets('Dashboard Screen UI', (WidgetTester tester) async {
      //Testing Dashboard Screen
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle(Duration(seconds: 5));
      print("Dashboard Screen Loaded");
      final Finder greetingText = find.byKey(Key('greetingText'));
      final Finder salesTargetText = find.byKey(Key('salesTargetText'));
      final Finder targetAmount = find.byKey(Key('targetAmount'));
      final Finder showRouteButton = find.byKey(Key('showRouteButton'));
      final Finder radialGaugeWidget = find.byKey(Key('radialGaugeWidget'));
      final Finder shopsProgression = find.byKey(Key('shopsProgression'));
      final Finder inventoryProgression =
          find.byKey(Key('inventoryProgression'));
      expect(greetingText, findsOneWidget);
      expect(salesTargetText, findsOneWidget);
      expect(targetAmount, findsOneWidget);
      expect(showRouteButton, findsOneWidget);
      expect(radialGaugeWidget, findsOneWidget);
      expect(shopsProgression, findsOneWidget);
      expect(inventoryProgression, findsOneWidget);
      print("Components of Dashboard Screen Loaded Correctly");
    });
  });

  group('Integration Test - Inventory Screen', () {
    testWidgets('Inventory Screen Navigation', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle(Duration(seconds: 5));
      //Tabs Screen
      final Finder inventoryIcon = find.byKey(Key('inventoryIcon'));
      await tester.tap(inventoryIcon);
      await tester.pumpAndSettle(Duration(seconds: 1));
      print("Navigated to Inventory Screen Correctly");

      //Testing Inventory Screen
      final Finder titleText = find.byKey(Key('titleText'));
      final Finder dataTable = find.byKey(Key('dataTable'));
      final Finder idColum = find.byKey(Key('idColum'));
      final Finder nameColum = find.byKey(Key('nameColum'));
      final Finder priceColum = find.byKey(Key('priceColum'));
      final Finder qntColum = find.byKey(Key('qntColum'));
      expect(titleText, findsOneWidget);
      expect(dataTable, findsOneWidget);
      expect(idColum, findsOneWidget);
      expect(nameColum, findsOneWidget);
      expect(priceColum, findsOneWidget);
      expect(qntColum, findsOneWidget);
    });
  });

  group('Integration Test - Shops Screen', () {
    testWidgets('Shops Screen Navigation', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle(Duration(seconds: 5));
      //Tabs Screen
      final Finder shopsIcon = find.byKey(Key('shopsIcon'));
      await tester.tap(shopsIcon);
      await tester.pumpAndSettle(Duration(seconds: 1));
      print("Navigated to Shops Screen Correctly");

      //Testing Shops Screen
      final Finder mapWidget = find.byKey(Key('mapWidget'));
      expect(mapWidget, findsOneWidget);
      expect(find.text('A Store'), findsOneWidget);
      await tester.fling(find.byType(ListView), Offset(0, -200), 3000);
      await tester.pumpAndSettle();
      expect(find.text('D Store'), findsOneWidget);
    });
  });
}
