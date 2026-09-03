import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/widgets/glass_card.dart';
import '../../nfc_management/presentation/nfc_write_sheet.dart';
import '../domain/nfc_template.dart';

/// Built-in template repository data.
const List<NfcTemplate> kBuiltInTemplates = [
  NfcTemplate(
    id: 'wifi_share',
    title: 'Wi-Fi Guest Access',
    description: 'Share Wi-Fi network credentials with a single tap.',
    category: 'Network',
    payloadType: 'wifi',
    defaultPayload: 'WIFI:S:MyHomeWiFi;T:WPA;P:SecretPassword123;;',
    iconName: 'wifi',
  ),
  NfcTemplate(
    id: 'vcard_contact',
    title: 'Digital Business Card',
    description: 'Share your name, phone, email, and company details.',
    category: 'Contact',
    payloadType: 'vcard',
    defaultPayload:
        'BEGIN:VCARD\nVERSION:3.0\nN:Doe;John;;;\nFN:John Doe\nTEL;TYPE=CELL:+15550199\nEMAIL:john@example.com\nORG:TipTapTup Tech\nEND:VCARD',
    iconName: 'contact',
  ),
  NfcTemplate(
    id: 'focus_timer',
    title: '5-Min Focus Timer',
    description: 'Tap tag to launch a 5-minute countdown focus timer.',
    category: 'Utility',
    payloadType: 'timer',
    defaultPayload: 'timer://300',
    iconName: 'timer',
  ),
  NfcTemplate(
    id: 'social_profile',
    title: 'Social Media Link',
    description:
        'Direct users to your Instagram, LinkedIn, or YouTube profile.',
    category: 'Social',
    payloadType: 'url',
    defaultPayload: 'https://instagram.com/tiptaptup_app',
    iconName: 'social',
  ),
  NfcTemplate(
    id: 'home_assistant',
    title: 'Smart Home Trigger',
    description: 'Trigger a Home Assistant or MQTT webhook automation.',
    category: 'Automation',
    payloadType: 'url',
    defaultPayload: 'https://home-assistant.local:8123/api/webhook/tag_scanned',
    iconName: 'home',
  ),
  NfcTemplate(
    id: 'emergency_info',
    title: 'Emergency Medical Note',
    description:
        'Write critical ICE medical details or emergency contact info.',
    category: 'Utility',
    payloadType: 'text',
    defaultPayload: 'ICE Contact: Jane Doe (+1-555-0123) | Blood Type: O+',
    iconName: 'medical',
  ),
];

class TemplatesTab extends ConsumerStatefulWidget {
  const TemplatesTab({super.key});

  @override
  ConsumerState<TemplatesTab> createState() => _TemplatesTabState();
}

class _TemplatesTabState extends ConsumerState<TemplatesTab> {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  static const List<String> kCategories = [
    'All',
    'Network',
    'Contact',
    'Utility',
    'Social',
    'Automation',
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final filtered = kBuiltInTemplates.where((t) {
      final categoryMatch =
          _selectedCategory == 'All' || t.category == _selectedCategory;
      final searchMatch =
          _searchQuery.isEmpty ||
          t.title.toLowerCase().contains(_searchQuery) ||
          t.description.toLowerCase().contains(_searchQuery);
      return categoryMatch && searchMatch;
    }).toList();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Templates',
            style: GoogleFonts.inter(
              fontSize: 34,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.8,
            ),
          ).animate().fadeIn(duration: 300.ms),
          const SizedBox(height: 4),
          Text(
            'Pre-configured NFC tags ready to program.',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF8E8E93) : const Color(0xFF8E8E93),
            ),
          ).animate().fadeIn(delay: 100.ms),

          const SizedBox(height: 16),

          // Apple iOS Search Bar
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1C1C1E)
                  : const Color(0xFFE5E5EA).withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? const Color(0xFF38383A) : Colors.transparent,
                width: 0.5,
              ),
            ),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search templates…',
                prefixIcon: Icon(
                  CupertinoIcons.search,
                  size: 20,
                  color: Color(0xFF8E8E93),
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 11,
                  horizontal: 14,
                ),
              ),
              onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
            ),
          ).animate().fadeIn(delay: 150.ms),

          const SizedBox(height: 14),

          // Category filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: kCategories.map((c) {
                final isSelected = c == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(c),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedCategory = c),
                  ),
                );
              }).toList(),
            ),
          ).animate().fadeIn(delay: 200.ms),

          const SizedBox(height: 16),

          // Template Grid / List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      'No matching templates found',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: cs.outline),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: filtered.length,
                    itemBuilder: (ctx, i) {
                      final template = filtered[i];
                      return _TemplateCard(
                            template: template,
                            onUse: () => _useTemplate(template),
                          )
                          .animate()
                          .fadeIn(delay: Duration(milliseconds: 250 + i * 50))
                          .slideY(begin: 0.1);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _useTemplate(NfcTemplate template) {
    WriteType type;
    switch (template.payloadType) {
      case 'url':
        type = WriteType.url;
        break;
      default:
        type = WriteType.text;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NfcWriteSheet(
        initialType: type,
        initialContent: template.defaultPayload,
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  final NfcTemplate template;
  final VoidCallback onUse;

  const _TemplateCard({required this.template, required this.onUse});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getIcon(template.iconName),
                    color: cs.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        template.title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: cs.secondary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          template.category.toUpperCase(),
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: cs.secondary,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              template.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.65),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onUse,
                icon: const Icon(Icons.nfc_rounded, size: 18),
                label: const Text('Use Template & Write Tag'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String iconName) => switch (iconName) {
    'wifi' => Icons.wifi_rounded,
    'contact' => Icons.badge_rounded,
    'timer' => Icons.timer_rounded,
    'social' => Icons.share_rounded,
    'home' => Icons.home_rounded,
    'medical' => Icons.medical_services_rounded,
    _ => Icons.widgets_rounded,
  };
}
