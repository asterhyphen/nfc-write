import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/automation_engine.dart';
import '../domain/automation_action.dart';
import '../../nfc_management/presentation/nfc_write_sheet.dart';

/// Sheet for creating a custom multi-step [AutomationProfile].
class CreateProfileSheet extends ConsumerStatefulWidget {
  const CreateProfileSheet({super.key});

  @override
  ConsumerState<CreateProfileSheet> createState() => _CreateProfileSheetState();
}

class _CreateProfileSheetState extends ConsumerState<CreateProfileSheet> {
  final _nameCtrl = TextEditingController(text: 'My NFC Profile');
  final List<AutomationAction> _actions = [];

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _addAction(AutomationAction action) {
    setState(() {
      _actions.add(action);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, ctrl) => Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: cs.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: ctrl,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Automation Profile',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Chain multiple actions executed sequentially when tag is tapped.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.6),
                          ),
                    ),
                    const SizedBox(height: 20),

                    // Profile Name
                    TextField(
                      controller: _nameCtrl,
                      decoration: InputDecoration(
                        labelText: 'Profile Name',
                        hintText: 'e.g. Work Mode, Bedtime',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        prefixIcon: const Icon(Icons.label_rounded),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Action List
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Action Sequence (${_actions.length})',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.add_circle_rounded),
                          tooltip: 'Add Action Step',
                          onSelected: (val) => _showAddActionDialog(val),
                          itemBuilder: (_) => const [
                            PopupMenuItem(
                              value: 'notification',
                              child: Row(
                                children: [
                                  Icon(Icons.notifications_rounded, size: 20),
                                  SizedBox(width: 10),
                                  Text('Notification'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'url',
                              child: Row(
                                children: [
                                  Icon(Icons.link_rounded, size: 20),
                                  SizedBox(width: 10),
                                  Text('Open Web URL'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'timer',
                              child: Row(
                                children: [
                                  Icon(Icons.timer_rounded, size: 20),
                                  SizedBox(width: 10),
                                  Text('Delay Timer'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'brightness',
                              child: Row(
                                children: [
                                  Icon(Icons.brightness_medium_rounded,
                                      size: 20),
                                  SizedBox(width: 10),
                                  Text('Set Brightness'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    if (_actions.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: cs.outlineVariant,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.playlist_add_rounded,
                                size: 40, color: cs.outline),
                            const SizedBox(height: 8),
                            Text(
                              'No actions added yet',
                              style: TextStyle(color: cs.outline),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tap + to add a notification, URL, or timer action.',
                              style: TextStyle(color: cs.outline, fontSize: 11),
                            ),
                          ],
                        ),
                      )
                    else
                      ReorderableListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _actions.length,
                        // ignore: deprecated_member_use
                        onReorder: (oldIndex, newIndex) {
                          setState(() {
                            if (newIndex > oldIndex) newIndex -= 1;
                            final item = _actions.removeAt(oldIndex);
                            _actions.insert(newIndex, item);
                          });
                        },
                        itemBuilder: (ctx, i) {
                          final action = _actions[i];
                          return Card(
                            key: ValueKey(i),
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 14,
                                backgroundColor: cs.primaryContainer,
                                child: Text('${i + 1}',
                                    style: TextStyle(
                                        fontSize: 12, color: cs.primary)),
                              ),
                              title: Text(_actionTitle(action)),
                              subtitle: Text(_actionSubtitle(action)),
                              trailing: IconButton(
                                icon: const Icon(Icons.close_rounded, size: 18),
                                onPressed: () {
                                  setState(() {
                                    _actions.removeAt(i);
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),

                    const SizedBox(height: 28),

                    // Run & Write Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _actions.isEmpty ? null : _testExecute,
                            icon: const Icon(Icons.play_arrow_rounded),
                            label: const Text('Test Profile'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _actions.isEmpty ? null : _writeToNfc,
                            icon: const Icon(Icons.nfc_rounded),
                            label: const Text('Write to Tag'),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 200.ms),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _actionTitle(AutomationAction a) => a.map(
        openUrl: (_) => 'Open Web URL',
        showNotification: (_) => 'Show Notification',
        launchApp: (_) => 'Launch App',
        setBrightness: (_) => 'Set Brightness',
        delayTimer: (_) => 'Delay Timer',
      );

  String _actionSubtitle(AutomationAction a) => a.map(
        openUrl: (x) => x.url,
        showNotification: (x) => '${x.title}: ${x.body}',
        launchApp: (x) => x.packageName,
        setBrightness: (x) => '${(x.level * 100).toInt()}%',
        delayTimer: (x) => '${x.seconds} seconds',
      );

  void _showAddActionDialog(String type) {
    final ctrl1 = TextEditingController();
    final ctrl2 = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add ${type.toUpperCase()} Action'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (type == 'notification') ...[
              TextField(
                controller: ctrl1,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: ctrl2,
                decoration: const InputDecoration(labelText: 'Message Body'),
              ),
            ] else if (type == 'url') ...[
              TextField(
                controller: ctrl1,
                decoration:
                    const InputDecoration(labelText: 'URL (https://...)'),
              ),
            ] else if (type == 'timer') ...[
              TextField(
                controller: ctrl1,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Duration in seconds (e.g. 60)'),
              ),
            ] else if (type == 'brightness') ...[
              TextField(
                controller: ctrl1,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Brightness % (0 - 100)'),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              if (type == 'notification') {
                _addAction(AutomationAction.showNotification(
                  title: ctrl1.text.isEmpty ? 'TapFlow' : ctrl1.text,
                  body: ctrl2.text.isEmpty ? 'Automation triggered!' : ctrl2.text,
                ));
              } else if (type == 'url') {
                _addAction(AutomationAction.openUrl(
                  url: ctrl1.text.isEmpty ? 'https://google.com' : ctrl1.text,
                ));
              } else if (type == 'timer') {
                final secs = int.tryParse(ctrl1.text) ?? 5;
                _addAction(AutomationAction.delayTimer(seconds: secs));
              } else if (type == 'brightness') {
                final percent = double.tryParse(ctrl1.text) ?? 80;
                _addAction(AutomationAction.setBrightness(level: percent / 100));
              }
            },
            child: const Text('Add Step'),
          ),
        ],
      ),
    );
  }

  void _testExecute() {
    final profile = AutomationProfile(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameCtrl.text,
      actions: _actions,
    );
    ref.read(automationEngineProvider).executeProfile(profile);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Executing profile "${_nameCtrl.text}"…')),
    );
  }

  void _writeToNfc() {
    Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const NfcWriteSheet(),
    );
  }
}
