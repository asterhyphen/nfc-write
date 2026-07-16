import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/widgets/glass_card.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: const [
            _DashboardTab(),
            _PlaceholderTab(title: 'Automations'),
            _PlaceholderTab(title: 'History'),
            _PlaceholderTab(title: 'Settings'),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
            label: 'Automations',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back,',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                  ),
                  Text(
                    'Creator',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const CircleAvatar(
                radius: 24,
                backgroundColor: Color(0xFF6200EE),
                child: Icon(Icons.person, color: Colors.white),
              )
            ],
          ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2),

          const SizedBox(height: 32),

          // Statistics Card
          GlassCard(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(label: 'Total Scans', value: '142'),
                Container(width: 1, height: 40, color: Colors.grey.withOpacity(0.3)),
                _StatItem(label: 'Active Profiles', value: '8'),
                Container(width: 1, height: 40, color: Colors.grey.withOpacity(0.3)),
                _StatItem(label: 'Favorites', value: '12'),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),

          const SizedBox(height: 32),

          // Quick Actions
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ).animate().fadeIn(delay: 300.ms),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.1,
            children: [
              _ActionCard(
                title: 'Read Tag',
                icon: Icons.nfc,
                color: Colors.blue,
                onTap: () {},
              ),
              _ActionCard(
                title: 'Write Tag',
                icon: Icons.edit,
                color: Colors.purple,
                onTap: () {},
              ),
              _ActionCard(
                title: 'Erase Tag',
                icon: Icons.delete_outline,
                color: Colors.redAccent,
                onTap: () {},
              ),
              _ActionCard(
                title: 'Scan QR',
                icon: Icons.qr_code_scanner,
                color: Colors.teal,
                onTap: () {},
              ),
            ],
          ).animate().fadeIn(delay: 400.ms).scale(),

          const SizedBox(height: 32),

          // Recent Activity
          Text(
            'Recent Activity',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ).animate().fadeIn(delay: 500.ms),
          const SizedBox(height: 16),
          
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: const Icon(Icons.history, size: 20),
                ),
                title: Text('Scanned "Office Wi-Fi"'),
                subtitle: Text('${index + 1} hour(s) ago'),
                trailing: const Icon(Icons.chevron_right),
              ).animate().fadeIn(delay: Duration(milliseconds: 600 + (index * 100))).slideX(begin: 0.2);
            },
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  final String title;
  const _PlaceholderTab({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$title (Coming Soon)',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}
