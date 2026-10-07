import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nav/data/contact_repository.dart';
import 'package:nav/main.dart';
import 'package:nav/models/contact_model.dart';
import 'package:nav/models/user_model.dart';
import 'package:nav/screens/detail/contact_profile_screen.dart';
import 'package:nav/screens/main_navigation_screen.dart';

void main() {
  testWidgets('App renders login screen and allows sign in', (WidgetTester tester) async {
    await tester.pumpWidget(const ContactDirectoryApp());

    expect(find.text('Directory Access'), findsOneWidget);
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);

    // Try signing in empty -> shows validation errors
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    expect(find.text('Username is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);

    // Fill in credentials
    await tester.enterText(find.byType(TextFormField).first, 'juan.admin');
    await tester.enterText(find.byType(TextFormField).last, 'secret123');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Verifies navigation to MainNavigationScreen (Dashboard)
    expect(find.text('Welcome, juan.admin'), findsOneWidget);
    expect(find.text('Maria Santos'), findsOneWidget);
  });

  testWidgets('Search and filter chips work on ContactListScreen', (WidgetTester tester) async {
    final user = UserModel(username: 'test.user', loggedInAt: DateTime.now());
    await tester.pumpWidget(MaterialApp(
      home: MainNavigationScreen(user: user),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Welcome, test.user'), findsOneWidget);
    expect(find.text('Maria Santos'), findsOneWidget);

    // Filter by category 'Family'
    await tester.tap(find.text('Family'));
    await tester.pumpAndSettle();

    expect(find.text('Corazon Aquino'), findsOneWidget);
    expect(find.text('Maria Santos'), findsNothing);

    // Switch back to 'All'
    await tester.tap(find.text('All'));
    await tester.pumpAndSettle();
    expect(find.text('Maria Santos'), findsOneWidget);

    // Search for Andres
    await tester.enterText(find.byType(TextField).first, 'Andres');
    await tester.pumpAndSettle();
    expect(find.text('Andres Bonifacio'), findsOneWidget);
    expect(find.text('Maria Santos'), findsNothing);
  });

  testWidgets('ContactProfileScreen displays contact info and action buttons', (WidgetTester tester) async {
    const contact = ContactModel(
      id: 'test_c',
      name: 'Maria Santos',
      role: 'Principal Cloud Architect',
      company: 'BayanTech Solutions Inc.',
      category: 'Work',
      phone: '+63 917 801 2345',
      email: 'maria.santos@bayantech.ph',
      address: 'Ayala Avenue, Makati City, Metro Manila',
      bio: 'Enterprise systems architect.',
      isFavorite: true,
    );

    await tester.pumpWidget(const MaterialApp(
      home: ContactProfileScreen(contact: contact),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Maria Santos'), findsOneWidget);
    expect(find.text('Principal Cloud Architect'), findsOneWidget);
    expect(find.text('+63 917 801 2345'), findsAtLeastNWidgets(1));
    expect(find.text('maria.santos@bayantech.ph'), findsOneWidget);
    expect(find.text('Call'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Message'), findsOneWidget);

    // Tap Call button
    await tester.tap(find.text('Call'));
    await tester.pump();
    expect(find.text('Initiating call: +63 917 801 2345'), findsOneWidget);
  });

  testWidgets('Repository toggles favorites properly', (WidgetTester tester) async {
    final initialFav = ContactRepository.instance.findById('c1')!.isFavorite;
    ContactRepository.instance.toggleFavorite('c1');
    expect(ContactRepository.instance.findById('c1')!.isFavorite, !initialFav);
    ContactRepository.instance.toggleFavorite('c1');
    expect(ContactRepository.instance.findById('c1')!.isFavorite, initialFav);
  });
}
