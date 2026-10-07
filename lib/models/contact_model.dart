class ContactModel {
  final String id;
  final String name;
  final String role;
  final String company;
  final String category; // 'Work', 'Personal', 'Family'
  final String phone;
  final String email;
  final String address;
  final String bio;
  final bool isFavorite;

  const ContactModel({
    required this.id,
    required this.name,
    required this.role,
    required this.company,
    required this.category,
    required this.phone,
    required this.email,
    required this.address,
    required this.bio,
    this.isFavorite = false,
  });

  ContactModel copyWith({
    String? id,
    String? name,
    String? role,
    String? company,
    String? category,
    String? phone,
    String? email,
    String? address,
    String? bio,
    bool? isFavorite,
  }) {
    return ContactModel(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      company: company ?? this.company,
      category: category ?? this.category,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      bio: bio ?? this.bio,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  String get initials {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
