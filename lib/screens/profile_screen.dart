import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../database/database_helper.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final int userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    setState(() => _isLoading = true);
    final user = await _dbHelper.getUserById(widget.userId);
    setState(() {
      _user = user;
      _isLoading = false;
    });
  }

  Future<void> _launchUrl(String url) async {
    if (url.isEmpty) return;

    String formattedUrl = url;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      formattedUrl = 'https://$url';
    }

    final uri = Uri.parse(formattedUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível abrir o link')),
        );
      }
    }
  }

  void _logout() {
    context.read<AuthService>().logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final canEdit = authService.canEditUser(widget.userId);
    final isOwnProfile = authService.currentUser?.id == widget.userId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          if (isOwnProfile)
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Sair',
              onPressed: _logout,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _user == null
          ? const Center(child: Text('Usuário não encontrado'))
          : RefreshIndicator(
              onRefresh: _loadUser,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // Header com foto e nome
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.blue.shade700, Colors.blue.shade900],
                        ),
                      ),
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            child: Text(
                              _user!.name[0].toUpperCase(),
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _user!.fullName,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          if (_user!.position.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              _user!.position,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                          if (_user!.isAdmin) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.shade700,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'ADMINISTRADOR',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Informações
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Informações de Contato
                          _buildSectionTitle('Informações de Contato'),
                          _buildInfoCard(
                            icon: Icons.email,
                            label: 'Email',
                            value: _user!.email,
                          ),

                          // Descrição
                          if (_user!.description.isNotEmpty) ...[
                            const SizedBox(height: 24),
                            _buildSectionTitle('Sobre'),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  _user!.description,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],

                          // Redes Sociais
                          if (_user!.website.isNotEmpty ||
                              _user!.facebook.isNotEmpty ||
                              _user!.instagram.isNotEmpty ||
                              _user!.linkedin.isNotEmpty) ...[
                            const SizedBox(height: 24),
                            _buildSectionTitle('Redes Sociais'),
                            if (_user!.website.isNotEmpty)
                              _buildSocialCard(
                                icon: Icons.language,
                                label: 'Website/Portfólio',
                                value: _user!.website,
                                onTap: () => _launchUrl(_user!.website),
                              ),
                            if (_user!.facebook.isNotEmpty)
                              _buildSocialCard(
                                icon: Icons.facebook,
                                label: 'Facebook',
                                value: _user!.facebook,
                                onTap: () => _launchUrl(_user!.facebook),
                              ),
                            if (_user!.instagram.isNotEmpty)
                              _buildSocialCard(
                                icon: Icons.camera_alt,
                                label: 'Instagram',
                                value: _user!.instagram,
                                onTap: () => _launchUrl(_user!.instagram),
                              ),
                            if (_user!.linkedin.isNotEmpty)
                              _buildSocialCard(
                                icon: Icons.work,
                                label: 'LinkedIn',
                                value: _user!.linkedin,
                                onTap: () => _launchUrl(_user!.linkedin),
                              ),
                          ],

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: canEdit
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (_) => EditProfileScreen(user: _user!),
                      ),
                    )
                    .then((_) => _loadUser());
              },
              icon: const Icon(Icons.edit),
              label: const Text('Editar Perfil'),
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
            )
          : null,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade900,
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.blue.shade700),
        title: Text(label),
        subtitle: Text(value),
      ),
    );
  }

  Widget _buildSocialCard({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.blue.shade700),
        title: Text(label),
        subtitle: Text(value),
        trailing: const Icon(Icons.open_in_new),
        onTap: onTap,
      ),
    );
  }
}
