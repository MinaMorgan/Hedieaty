import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hedieaty/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
      'Workflow: Login, add private event, add gift, publish event, and pledge another user\'s gift',
          (tester) async {
        // Launch the app
        app.main();
        await tester.pumpAndSettle();

        //Sign Up Step
        await _navigateToRegisterPage(tester);
        await tester.pumpAndSettle();

        // Sign Up Step
        await _performSignUp(tester);
        await tester.pumpAndSettle();

        // Login Step
        await _performLogin1(tester);
        await tester.pumpAndSettle();

        // Navigate to Events Page
        await _navigateToEventsPage(tester);
        await tester.pumpAndSettle();

        // Add a Public Event
        await _addPublicEvent(tester);
        await tester.pumpAndSettle();

        // Navigate to Gift
        await _navigateToGifts(tester);
        await tester.pumpAndSettle();

        // Add a Gift
        await _addPublicGift(tester);
        await tester.pumpAndSettle();

        // Go Back
        await _navigateBack(tester);
        await tester.pumpAndSettle();

        // Add a Gift
        await _performLogout(tester);
        await tester.pumpAndSettle();

        // Login Step
        await _performLogin2(tester);
        await tester.pumpAndSettle();

        // Add a Friend
        await _addFriend(tester);
        await tester.pumpAndSettle();

        // Add a Friend
        await _navigateToFriendEvents(tester);
        await tester.pumpAndSettle();

        // Navigate to Gift
        await _navigateToGifts(tester);
        await tester.pumpAndSettle();

        // Pledge Gift
        await _pledgeGift(tester);
        await tester.pumpAndSettle();
        expect(find.text('Pledged'), findsOneWidget);

      });
}

// Method for Navigating to Events Page
Future<void> _navigateToRegisterPage(WidgetTester tester) async {
  await tester.pumpAndSettle();
  final registerPageButton = find.byKey(const Key('registerButton'));

  expect(registerPageButton, findsOneWidget);

  await tester.tap(registerPageButton);
  await tester.pumpAndSettle();
}

// Method for Sign Up
Future<void> _performSignUp(WidgetTester tester) async {
  final nameField = find.byKey(const Key('nameField'));
  final phoneField = find.byKey(const Key('phoneField'));
  final emailField = find.byKey(const Key('emailField'));
  final passwordField = find.byKey(const Key('passwordField'));
  final confirmPasswordField = find.byKey(const Key('confirmPasswordField'));
  final registerButton = find.byKey(const Key('registerButton'));

  expect(nameField, findsOneWidget);
  expect(phoneField, findsOneWidget);
  expect(emailField, findsOneWidget);
  expect(passwordField, findsOneWidget);
  expect(confirmPasswordField, findsOneWidget);
  expect(registerButton, findsOneWidget);

  await tester.enterText(nameField, 'Mina Morgan');
  await tester.pumpAndSettle();
  await tester.enterText(phoneField, '01203036092');
  await tester.pumpAndSettle();
  await tester.enterText(emailField, 'test@test.com');
  await tester.pumpAndSettle();
  await tester.enterText(passwordField, '123456');
  await tester.pumpAndSettle();
  await tester.enterText(confirmPasswordField, '123456');
  await tester.pumpAndSettle();

  await tester.ensureVisible(registerButton);
  await tester.pumpAndSettle();

  // Tap the button
  await tester.tap(registerButton);
  await tester.pumpAndSettle();
  await Future.delayed(Duration(seconds: 10));
}

// Method for Login
Future<void> _performLogin1(WidgetTester tester) async {
  final loginEmailField = find.byKey(const Key('emailField'));
  final loginPasswordField = find.byKey(const Key('passwordField'));
  final loginButton = find.byKey(const Key('loginButton'));

  expect(loginEmailField, findsOneWidget);
  expect(loginPasswordField, findsOneWidget);

  // Ensure loginButton is visible before tapping
  await tester.pumpAndSettle();  // Allow time for widget tree to settle
  await tester.ensureVisible(loginButton);  // Make sure the button is visible
  await tester.pumpAndSettle();  // Give it time to be settled

  expect(loginButton, findsOneWidget);

  await tester.enterText(loginEmailField, 'test@test.com');
  await tester.pumpAndSettle();
  await tester.enterText(loginPasswordField, '123456');
  await tester.pumpAndSettle();
  await tester.tap(loginButton);
  await tester.pumpAndSettle();
}

// Method for Navigating to Events Page
Future<void> _navigateToEventsPage(WidgetTester tester) async {
  final eventsButton = find.byIcon(Icons.card_giftcard);

  expect(eventsButton, findsOneWidget);

  await tester.tap(eventsButton);
  await tester.pumpAndSettle();
}

// Method for Adding a Public Event
Future<void> _addPublicEvent(WidgetTester tester) async {
  final addButton = find.byIcon(Icons.add);

  expect(addButton, findsOneWidget);

  await tester.tap(addButton);
  await tester.pumpAndSettle();

  final eventNameField = find.byKey(const Key('titleField'));
  final eventDescriptionField = find.byKey(const Key('descriptionField'));
  final eventDateField = find.byKey(const Key('dateField'));
  //final eventPrivateSwitch = find.byKey(const Key('eventTypeSwitch'));
  final createEventButton = find.byKey(const Key('saveButton'));

  expect(eventNameField, findsOneWidget);
  expect(eventDescriptionField, findsOneWidget);
  expect(eventDateField, findsOneWidget);
  //expect(eventPrivateSwitch, findsOneWidget);
  expect(createEventButton, findsOneWidget);

  await tester.enterText(eventNameField, 'Event 1');
  await tester.pumpAndSettle();
  await tester.enterText(eventDescriptionField, 'This is a event for testing.');
  await tester.pumpAndSettle();
  await tester.tap(find.byIcon(Icons.calendar_today));
  await tester.pumpAndSettle();
  await tester.tap(find.text('30'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
  //await tester.tap(eventPrivateSwitch);
  await tester.tap(createEventButton);
  await tester.pumpAndSettle();
}

// Method for Navigating to Gifts Page
Future<void> _navigateToGifts(WidgetTester tester) async {
  await tester.tap(find.text('Event 1'));
  await tester.pumpAndSettle();
}

// Method for Adding a Public Gift
Future<void> _addPublicGift(WidgetTester tester) async {
  final addButton = find.byIcon(Icons.add);

  expect(addButton, findsOneWidget);

  await tester.tap(addButton);
  await tester.pumpAndSettle();

  final giftNameField = find.byKey(const Key('nameField'));
  final giftDescriptionField = find.byKey(const Key('descriptionField'));
  final giftCategoryField = find.byKey(const Key('categoryDropdown'));
  final giftPriceField = find.byKey(const Key('priceField'));
  final createGiftButton = find.byKey(const Key('createButton'));

  expect(giftNameField, findsOneWidget);
  expect(giftDescriptionField, findsOneWidget);
  expect(giftCategoryField, findsOneWidget);
  expect(giftPriceField, findsOneWidget);
  expect(createGiftButton, findsOneWidget);

  await tester.enterText(giftNameField, 'Gift 1');
  await tester.pumpAndSettle();
  await tester.enterText(giftDescriptionField, 'This is a gift for testing.');
  await tester.pumpAndSettle();
  await tester.tap(giftCategoryField);
  await tester.pumpAndSettle();
  await tester.tap(find.text('Electronics'));
  await tester.pumpAndSettle();
  await tester.enterText(giftPriceField, '100');
  await tester.tap(createGiftButton);
  await tester.pumpAndSettle();
}

// Go Back
Future<void> _navigateBack(WidgetTester tester) async {
  // Simulate pressing the back button (reverse push)
  await tester.pageBack();
  await tester.pumpAndSettle();
}

// Method for Logout
Future<void> _performLogout(WidgetTester tester) async {
  final profileButton = find.byIcon(Icons.person);

  expect(profileButton, findsOneWidget);

  await tester.tap(profileButton);
  await tester.pumpAndSettle();
  await tester.tap(find.text('Log Out'));
  await tester.pumpAndSettle();
}

// Method for Login
Future<void> _performLogin2(WidgetTester tester) async {
  final loginEmailField = find.byKey(const Key('emailField'));
  final loginPasswordField = find.byKey(const Key('passwordField'));
  final loginButton = find.byKey(const Key('loginButton'));

  expect(loginEmailField, findsOneWidget);
  expect(loginPasswordField, findsOneWidget);
  expect(loginButton, findsOneWidget);

  await tester.enterText(loginEmailField, 'minammorgan21@gmail.com');
  await tester.pumpAndSettle();
  await tester.enterText(loginPasswordField, '123456');
  await tester.pumpAndSettle();
  await tester.tap(loginButton);
  await tester.pumpAndSettle();
}

// Method for Adding a Friend
Future<void> _addFriend(WidgetTester tester) async {
  final addButton = find.byIcon(Icons.add);

  expect(addButton, findsOneWidget);

  await tester.tap(addButton);
  await tester.pumpAndSettle();

  final typeField = find.byKey(const Key('addByPhoneButton'));
  final inputField = find.byKey(const Key('inputField'));
  final addFriendButton = find.byKey(const Key('addFriendButton'));

  expect(typeField, findsOneWidget);
  expect(inputField, findsOneWidget);
  expect(addFriendButton, findsOneWidget);

  await tester.tap(typeField);
  await tester.pumpAndSettle();
  await tester.enterText(inputField, '01203036092');
  await tester.tap(addFriendButton);
  await Future.delayed(Duration(seconds: 2));
  await tester.pumpAndSettle();
}

// Method for Navigating to Friend's events
Future<void> _navigateToFriendEvents(WidgetTester tester) async {
  await tester.tap(find.text('Mina Morgan'));
  await tester.pumpAndSettle();
}

// Method for Pledgeing Gift
Future<void> _pledgeGift(WidgetTester tester) async {
  await tester.tap(find.text('Gift 1'));
  await tester.pumpAndSettle();

  final pledgeButton = find.byKey(const Key('pledgeButton'));

  expect(pledgeButton, findsOneWidget);

  await tester.tap(pledgeButton);
  await tester.pumpAndSettle();
}