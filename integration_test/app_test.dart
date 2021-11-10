import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:smart_pos/main.dart';
import 'package:smart_pos/widgets/sales_item_widget.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Integration Test - Auth & Tabs Screens', () {
    testWidgets('Auth Screen UI/Navigation and Tabs Screen UI/Navigation',
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
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.byKey(Key('bottom')), findsOneWidget);
      final Finder dashboardIcon = find.byKey(Key('dashboardIcon'));
      final Finder inventoryIcon = find.byKey(Key('inventoryIcon'));
      final Finder shopsIcon = find.byKey(Key('shopsIcon'));
      expect(dashboardIcon, findsOneWidget);
      expect(inventoryIcon, findsOneWidget);
      expect(shopsIcon, findsOneWidget);
      print("Components of Tabs Screen Loaded Correctly");

      await tester.tap(inventoryIcon);
      await tester.pumpAndSettle(Duration(seconds: 1));
      print("Navigated to Inventory Screen Correctly");
      await tester.tap(shopsIcon);
      await tester.pumpAndSettle(Duration(seconds: 1));
      print("Navigated to Shops Screen Correctly");
    });
  });

  group('Integration Test - Dashboard Screen', () {
    testWidgets('Dashboard Screen UI/Navigation', (WidgetTester tester) async {
      //Testing Dashboard Screen
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle(Duration(seconds: 1));
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
    testWidgets('Inventory Screen UI/Navigation', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle(Duration(seconds: 1));
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
      print("Components of Inventory Screen Loaded Correctly");
    });
  });

  group('Integration Test - Drawer/ Payment Screen', () {
    testWidgets('Drawer/ Payment Screen UI/Navigation',
        (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle(Duration(seconds: 1));
      //Tabs Screen
      final Finder drawer = find.byKey(Key('drawer'));
      await tester.dragFrom(
          tester.getTopLeft(find.byType(MaterialApp)), Offset(300, 0));
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(drawer, findsOneWidget);
      print("Opened Drawer Correctly");

      //Testing Drawer
      final Finder home = find.byKey(Key('home'));
      final Finder sales = find.byKey(Key('sales'));
      final Finder logout = find.byKey(Key('logout'));
      expect(home, findsOneWidget);
      expect(sales, findsOneWidget);
      expect(logout, findsOneWidget);
      print("Components of Drawer Loaded Correctly");

      await tester.tap(sales);
      await tester.pumpAndSettle(Duration(seconds: 1));
      print("Navigated to Payments Screen Correctly");

      //Sales Screen
      final Finder totalText = find.byKey(Key('totalText'));
      final Finder totalAmount = find.byKey(Key('totalAmount'));
      final Finder inTheHandMoneyText = find.byKey(Key('inTheHandMoneyText'));
      final Finder totalMoney = find.byKey(Key('totalMoney'));
      final Finder salesItem = find.byType(SalesItem);
      expect(totalText, findsOneWidget);
      expect(totalAmount, findsOneWidget);
      expect(inTheHandMoneyText, findsOneWidget);
      expect(totalMoney, findsOneWidget);
      expect(salesItem, findsOneWidget);
      print("Components of Sales Screen Loaded Correctly");

      //Inovice
      final Finder card = find.byKey(Key('card'));
      final Finder idText = find.byKey(Key('idText'));
      final Finder chip = find.byKey(Key("chip"));
      final Finder onlineChip = find.byKey(Key("onlineChip"));
      final Finder expandButton = find.byKey(Key("expandButton"));
      expect(card, findsOneWidget);
      expect(idText, findsOneWidget);
      expect(onlineChip, findsOneWidget);
      expect(chip, findsOneWidget);
      expect(expandButton, findsOneWidget);
      await tester.tap(expandButton);
      await tester.pumpAndSettle(Duration(seconds: 1));

      final Finder dataTable = find.byKey(Key("dataTable"));
      expect(dataTable, findsOneWidget);
      print("Components of Mock Invoice Loaded Correctly");
    });
  });

  group('Integration Test - Shops Screen', () {
    testWidgets('Shops Screen UI/Navigation', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle(Duration(seconds: 1));
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
      print("Scrolled Shops List Correctly");

      expect(find.text('D Store'), findsOneWidget);
      print("Components of Shops Screen Loaded Correctly");

      await tester.tap(find.text('D Store'));
      await tester.pumpAndSettle(Duration(seconds: 1));

      //Shop Detail Screen
      print("Navigated to Shops Detail Screen Correctly");
      final Finder titleText = find.byKey(Key('titleText'));
      final Finder cpText = find.byKey(Key('cpText'));
      final Finder addText = find.byKey(Key("addText"));
      final Finder phoneIcon = find.byKey(Key('phoneIcon'));
      final Finder shopMapWidget = find.byKey(Key('shopMapWidget'));
      final Finder invoiceButton = find.byKey(Key('invoiceButton'));
      expect(titleText, findsOneWidget);
      expect(cpText, findsOneWidget);
      expect(addText, findsOneWidget);
      expect(phoneIcon, findsOneWidget);
      expect(shopMapWidget, findsOneWidget);
      expect(invoiceButton, findsOneWidget);
      print("Components of Shop Detail Screen Loaded Correctly");

      await tester.tap(invoiceButton);
      await tester.pumpAndSettle(Duration(seconds: 1));

      //Shop Payment Screen
      final Finder addNewButton = find.byKey(Key('addNewButton'));
      final Finder dataTable = find.byKey(Key('dataTable'));
      final Finder total = find.byKey(Key('total'));
      final Finder floatingButton = find.byKey(Key('floatingButton'));

      expect(find.text('Invoice for D Store'), findsOneWidget);
      expect(total, findsOneWidget);
      expect(dataTable, findsOneWidget);
      expect(addNewButton, findsOneWidget);
      expect(floatingButton, findsOneWidget);
      print("Components of Shop Payment Screen Loaded Correctly");

      await tester.tap(addNewButton);
      await tester.pumpAndSettle(Duration(seconds: 1));

      final Finder modal = find.byKey(Key('modal'));
      final Finder qntField = find.byKey(Key('qntField'));
      final Finder addButton = find.byKey(Key('addButton'));
      final Finder nameText = find.byKey(Key('nameText'));
      final Finder priceText = find.byKey(Key('priceText'));
      final Finder nameField = find.byKey(Key('nameField'));
      final Finder priceField = find.byKey(Key('priceField'));
      expect(qntField, findsOneWidget);
      expect(modal, findsOneWidget);
      expect(addButton, findsOneWidget);
      expect(nameText, findsOneWidget);
      expect(priceText, findsOneWidget);
      expect(nameField, findsOneWidget);
      expect(priceField, findsOneWidget);
      print("Components of Bottom Modal Loaded Correctly");

      await tester.tap(find.byKey(Key('qntField')));
      await tester.enterText(qntField, "5");

      await tester.tap(addButton);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.tap(floatingButton);
      await tester.pumpAndSettle(Duration(seconds: 1));

      final Finder alertDialog = find.byKey(Key('alertDialog'));
      expect(alertDialog, findsOneWidget);
      print("Mock Payemnt UI Components Working Correctly");
    });
  });
}
