import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:todo_list/models/note.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class Storage {
  // NOTE: For demo purposes we use a hard-coded key. For production,
  // store keys securely (e.g., Keychain / Keystore or user passphrase).
  static final _key = encrypt.Key.fromUtf8('0123456789abcdef0123456789abcdef');
  static final _iv = encrypt.IV.fromLength(16);
  static final _encrypter = encrypt.Encrypter(encrypt.AES(_key));

  static Future<File> _localFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/notes.json');
  }

  static Future<List<Note>> loadNotes() async {
    try {
      final f = await _localFile();
      if (!await f.exists()) return [];
      final cipher = await f.readAsString();
      if (cipher.trim().isEmpty) return [];
      try {
        final jsonStr = _encrypter.decrypt64(cipher, iv: _iv);
        if (jsonStr.trim().isEmpty) return [];
        return Note.listFromJson(jsonStr);
      } catch (_) {
        // If decryption fails, try to parse as plain JSON (backwards compatibility)
        try {
          return Note.listFromJson(cipher);
        } catch (_) {
          return [];
        }
      }
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveNotes(List<Note> notes) async {
    final f = await _localFile();
    final jsonStr = Note.listToJson(notes);
    final cipher = _encrypter.encrypt(jsonStr, iv: _iv).base64;
    await f.writeAsString(cipher);
  }
}
