class User {
  int? id;
  String name;
  String lastName;
  String email;
  String password;
  String role; // 'admin' or 'normal'
  String position;
  String description;
  String website;
  String facebook;
  String instagram;
  String linkedin;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    this.id,
    required this.name,
    required this.lastName,
    required this.email,
    required this.password,
    this.role = 'normal',
    this.position = '',
    this.description = '',
    this.website = '',
    this.facebook = '',
    this.instagram = '',
    this.linkedin = '',
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // Converter para Map para salvar no banco
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lastName': lastName,
      'email': email,
      'password': password,
      'role': role,
      'position': position,
      'description': description,
      'website': website,
      'facebook': facebook,
      'instagram': instagram,
      'linkedin': linkedin,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Criar User a partir de Map do banco
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      lastName: map['lastName'],
      email: map['email'],
      password: map['password'],
      role: map['role'],
      position: map['position'] ?? '',
      description: map['description'] ?? '',
      website: map['website'] ?? '',
      facebook: map['facebook'] ?? '',
      instagram: map['instagram'] ?? '',
      linkedin: map['linkedin'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  // Obter nome completo
  String get fullName => '$name $lastName';

  // Verificar se é admin
  bool get isAdmin => role == 'admin';

  // Copiar com modificações
  User copyWith({
    int? id,
    String? name,
    String? lastName,
    String? email,
    String? password,
    String? role,
    String? position,
    String? description,
    String? website,
    String? facebook,
    String? instagram,
    String? linkedin,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      position: position ?? this.position,
      description: description ?? this.description,
      website: website ?? this.website,
      facebook: facebook ?? this.facebook,
      instagram: instagram ?? this.instagram,
      linkedin: linkedin ?? this.linkedin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
