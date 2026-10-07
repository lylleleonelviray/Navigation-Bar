import 'package:flutter/material.dart';
import '../../data/contact_repository.dart';
import '../../models/contact_model.dart';
import '../../theme/app_theme.dart';

class ContactProfileScreen extends StatefulWidget {
  final ContactModel contact;

  const ContactProfileScreen({
    super.key,
    required this.contact,
  });

  @override
  State<ContactProfileScreen> createState() => _ContactProfileScreenState();
}

class _ContactProfileScreenState extends State<ContactProfileScreen> {
  late ContactModel _currentContact;

  @override
  void initState() {
    super.initState();
    _currentContact = widget.contact;
  }

  void _toggleFavorite() {
    ContactRepository.instance.toggleFavorite(_currentContact.id);
    final updated = ContactRepository.instance.findById(_currentContact.id);
    if (updated != null) {
      setState(() {
        _currentContact = updated;
      });
    }
  }

  void _showActionFeedback(String actionName, String target) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$actionName: $target'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<ContactModel>>(
      valueListenable: ContactRepository.instance.contactsListenable,
      builder: (context, contacts, _) {
        final syncedContact = contacts.firstWhere(
          (c) => c.id == _currentContact.id,
          orElse: () => _currentContact,
        );

        return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: AppBar(
            title: const Text('Contact Details'),
            actions: [
              IconButton(
                tooltip: syncedContact.isFavorite ? 'Remove Favorite' : 'Save to Favorites',
                icon: Icon(
                  syncedContact.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: syncedContact.isFavorite ? AppTheme.indigo600 : AppTheme.slate600,
                ),
                onPressed: _toggleFavorite,
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 580),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Card
                    Container(
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 44,
                            backgroundColor: AppTheme.slate900,
                            child: Text(
                              syncedContact.initials,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            syncedContact.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.slate900,
                              letterSpacing: -0.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            syncedContact.role,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.slate600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            syncedContact.company,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.slate500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.slate100,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppTheme.slate200),
                            ),
                            child: Text(
                              syncedContact.category,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.slate700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Quick Action Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _QuickActionButton(
                                icon: Icons.phone_outlined,
                                label: 'Call',
                                onTap: () => _showActionFeedback('Initiating call', syncedContact.phone),
                              ),
                              const SizedBox(width: 14),
                              _QuickActionButton(
                                icon: Icons.mail_outline_rounded,
                                label: 'Email',
                                onTap: () => _showActionFeedback('Opening email client', syncedContact.email),
                              ),
                              const SizedBox(width: 14),
                              _QuickActionButton(
                                icon: Icons.chat_bubble_outline_rounded,
                                label: 'Message',
                                onTap: () => _showActionFeedback('Sending message to', syncedContact.phone),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Contact Information Section
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Contact Information',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.slate900,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _InfoTile(
                            icon: Icons.phone_outlined,
                            label: 'Phone Number',
                            value: syncedContact.phone,
                            onTap: () => _showActionFeedback('Initiating call', syncedContact.phone),
                          ),
                          const Divider(height: 24),
                          _InfoTile(
                            icon: Icons.email_outlined,
                            label: 'Email Address',
                            value: syncedContact.email,
                            onTap: () => _showActionFeedback('Composing mail to', syncedContact.email),
                          ),
                          const Divider(height: 24),
                          _InfoTile(
                            icon: Icons.place_outlined,
                            label: 'Physical Address',
                            value: syncedContact.address,
                            onTap: () => _showActionFeedback('Locating address', syncedContact.address),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Biography Section
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Biography',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.slate900,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            syncedContact.bio,
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.6,
                              color: AppTheme.slate700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.slate50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.slate200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppTheme.slate800),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.slate800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.slate100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: AppTheme.slate700),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.slate500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.slate900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
