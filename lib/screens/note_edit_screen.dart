import 'package:flutter/material.dart';
import 'package:todo_list/models/note.dart';

class NoteEditScreen extends StatefulWidget {
  final Note note;

  const NoteEditScreen({super.key, required this.note});

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  Future<bool> _onWillPop() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tiêu đề không được để trống')),
      );
      return false;
    }
    final updated = Note(id: widget.note.id, title: title, content: content, modifiedAt: DateTime.now());
    Navigator.of(context).pop(updated);
    return false;
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _save() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tiêu đề không được để trống')),
      );
      return;
    }
    final updated = Note(id: widget.note.id, title: title, content: content, modifiedAt: DateTime.now());
    Navigator.of(context).pop(updated);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Xem / Sửa ghi chú'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Tiêu đề', border: OutlineInputBorder()),
                maxLines: 1,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: TextField(
                  controller: _contentController,
                  decoration: const InputDecoration(labelText: 'Nội dung', border: OutlineInputBorder()),
                  maxLines: null,
                  expands: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
