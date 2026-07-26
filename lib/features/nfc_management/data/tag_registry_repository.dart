import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'tag_registry_repository.g.dart';

const _kTagRegistryKey = 'tapflow_tag_registry';

/// Repository that stores custom names/identifiers assigned to NFC tag contents.
class TagRegistryRepository {
  final SharedPreferences _prefs;
  TagRegistryRepository(this._prefs);

  /// Gets the custom assigned name for a tag's content, if any.
  String? getTagName(String content) {
    final raw = _prefs.getString(_kTagRegistryKey);
    if (raw == null) return null;
    final Map<String, dynamic> map = jsonDecode(raw);
    return map[content] as String?;
  }

  /// Assigns or updates a custom name for a tag's content.
  Future<void> setTagName(String content, String customName) async {
    final raw = _prefs.getString(_kTagRegistryKey);
    final Map<String, dynamic> map = raw != null ? jsonDecode(raw) : {};
    map[content] = customName.trim();
    await _prefs.setString(_kTagRegistryKey, jsonEncode(map));
  }

  /// Removes a custom assigned tag name.
  Future<void> removeTagName(String content) async {
    final raw = _prefs.getString(_kTagRegistryKey);
    if (raw == null) return;
    final Map<String, dynamic> map = jsonDecode(raw);
    map.remove(content);
    await _prefs.setString(_kTagRegistryKey, jsonEncode(map));
  }

  /// Gets all registered tag names.
  Map<String, String> getAllTagNames() {
    final raw = _prefs.getString(_kTagRegistryKey);
    if (raw == null) return {};
    final Map<String, dynamic> map = jsonDecode(raw);
    return map.map((k, v) => MapEntry(k, v.toString()));
  }
}

@riverpod
Future<TagRegistryRepository> tagRegistryRepository(Ref ref) async {
  final prefs = await SharedPreferences.getInstance();
  return TagRegistryRepository(prefs);
}
