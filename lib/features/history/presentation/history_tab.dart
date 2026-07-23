import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../domain/scan_record.dart';
import 'history_notifier.dart';

/// Full scan history tab — searchable, favouritable, deletable.
class HistoryTab extends ConsumerStatefulWidget {
  const HistoryTab({super.key});

  @override
  ConsumerState<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends ConsumerState<HistoryTab> {
  String _query = '';
  bool _favOnly = false;

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(historyProvider);

    return Column(
      children: [
        // ── Search bar ──────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search history…',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  onChanged: (v) => setState(() => _query = v.toLowerCase()),
                ),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('★'),
                selected: _favOnly,
                onSelected: (v) => setState(() => _favOnly = v),
              ),
            ],
          ),
        ),
        // ── List ────────────────────────────────────────────────────────────
        Expanded(
          child: historyAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (records) {
              final filtered = records.where((r) {
                if (_favOnly && !r.isFavorite) return false;
                if (_query.isEmpty) return true;
                return r.content.toLowerCase().contains(_query) ||
                    r.tagType.toLowerCase().contains(_query);
              }).toList();

              if (filtered.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.history_toggle_off,
                        size: 64,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No records yet',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filtered.length,
                itemBuilder: (ctx, i) {
                  final r = filtered[i];
                  return _RecordTile(record: r)
                      .animate()
                      .fadeIn(delay: Duration(milliseconds: i * 40))
                      .slideX(begin: 0.1);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RecordTile extends ConsumerWidget {
  final ScanRecord record;
  const _RecordTile({required this.record});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: cs.primaryContainer,
          child: Icon(_iconFor(record.tagType), size: 18, color: cs.primary),
        ),
        title: Text(
          record.content,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${record.tagType} · ${DateFormat.yMMMd().add_jm().format(record.scannedAt)}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                record.isFavorite ? Icons.star : Icons.star_border,
                color: record.isFavorite ? Colors.amber : null,
              ),
              onPressed: () => ref
                  .read(historyProvider.notifier)
                  .toggleFavorite(record.id),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => ref
                  .read(historyProvider.notifier)
                  .deleteRecord(record.id),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(String type) {
    switch (type.toLowerCase()) {
      case 'url':
        return Icons.link;
      case 'text':
        return Icons.text_fields;
      case 'wifi':
        return Icons.wifi;
      case 'email':
        return Icons.email;
      case 'phone':
        return Icons.phone;
      case 'sms':
        return Icons.sms;
      default:
        return Icons.nfc;
    }
  }
}
