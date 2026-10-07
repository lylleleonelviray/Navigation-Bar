import 'package:flutter/foundation.dart';
import '../models/contact_model.dart';

class ContactRepository {
  ContactRepository._internal() {
    _contactsNotifier = ValueNotifier<List<ContactModel>>(_initialContacts);
  }

  static final ContactRepository instance = ContactRepository._internal();

  late final ValueNotifier<List<ContactModel>> _contactsNotifier;

  ValueListenable<List<ContactModel>> get contactsListenable => _contactsNotifier;

  List<ContactModel> get contacts => _contactsNotifier.value;

  static const List<String> categories = ['All', 'Work', 'Personal', 'Family'];

  static final List<ContactModel> _initialContacts = [
    const ContactModel(
      id: 'c1',
      name: 'Maria Santos',
      role: 'Principal Cloud Architect',
      company: 'BayanTech Solutions Inc.',
      category: 'Work',
      phone: '+63 917 801 2345',
      email: 'maria.santos@bayantech.ph',
      address: 'Ayala Avenue, Makati City, Metro Manila',
      bio:
          'Specializes in enterprise distributed systems and hybrid cloud migrations. Active speaker at national software architecture summits.',
      isFavorite: true,
    ),
    const ContactModel(
      id: 'c2',
      name: 'Juan dela Cruz',
      role: 'Lead Mobile Engineer',
      company: 'Manila Software Labs',
      category: 'Work',
      phone: '+63 918 555 6789',
      email: 'juan.delacruz@manilalabs.io',
      address: 'Ortigas Center, Pasig City, Metro Manila',
      bio:
          'Dedicated Flutter and cross-platform mobile developer with a decade of experience crafting high-throughput consumer applications.',
      isFavorite: true,
    ),
    const ContactModel(
      id: 'c3',
      name: 'Jose Reyes',
      role: 'Chief Pediatric Consultant',
      company: 'Philippine Medical Center',
      category: 'Personal',
      phone: '+63 920 312 9081',
      email: 'jreyes.md@pmc.gov.ph',
      address: 'E. Rodriguez Sr. Avenue, Quezon City, Metro Manila',
      bio:
          'Board-certified pediatric specialist focused on preventative child healthcare, clinical research, and regional public health education.',
      isFavorite: false,
    ),
    const ContactModel(
      id: 'c4',
      name: 'Andres Bonifacio',
      role: 'Community Outreach Director',
      company: 'Katipunan Civic Foundation',
      category: 'Personal',
      phone: '+63 908 444 1896',
      email: 'andres.bonifacio@katipunan.org.ph',
      address: 'Monumento Circle, Caloocan City, Metro Manila',
      bio:
          'Directs grass-roots community empowerment programs, worker welfare seminars, and civic literacy campaigns across Luzon.',
      isFavorite: true,
    ),
    const ContactModel(
      id: 'c5',
      name: 'Gabriela Silang',
      role: 'Senior Civil Rights Attorney',
      company: 'Silang & Associates Legal',
      category: 'Work',
      phone: '+63 917 763 2021',
      email: 'gabriela.silang@silanglaw.ph',
      address: 'Vigan Heritage District, Ilocos Sur',
      bio:
          'Advocate for human rights, labor standard enforcement, and equitable legal representation for underserved indigenous communities.',
      isFavorite: false,
    ),
    const ContactModel(
      id: 'c6',
      name: 'Corazon Aquino',
      role: 'Institutional Governance Trustee',
      company: 'Civic Democracy Institute',
      category: 'Family',
      phone: '+63 919 198 6001',
      email: 'corazon.aquino@civicgovernance.ph',
      address: 'Times Street, Quezon City, Metro Manila',
      bio:
          'Advises public-private non-profit trusts, ethics compliance committees, and civic education foundations.',
      isFavorite: false,
    ),
    const ContactModel(
      id: 'c7',
      name: 'Emilio Jacinto',
      role: 'Information Security Officer',
      company: 'Kalayaan Digital Defense',
      category: 'Family',
      phone: '+63 922 833 7199',
      email: 'emilio.jacinto@kalayaan.ph',
      address: 'Bonifacio Global City, Taguig City, Metro Manila',
      bio:
          'Researcher in cryptographic protocols, ethical security audits, and national data sovereignty safeguards.',
      isFavorite: false,
    ),
  ];

  void toggleFavorite(String contactId) {
    _contactsNotifier.value = [
      for (final contact in _contactsNotifier.value)
        if (contact.id == contactId)
          contact.copyWith(isFavorite: !contact.isFavorite)
        else
          contact,
    ];
  }

  ContactModel? findById(String id) {
    try {
      return _contactsNotifier.value.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
