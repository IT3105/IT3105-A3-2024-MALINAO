import 'package:flutter/material.dart';
import 'dart:convert';

class JournalApp extends StatefulWidget {
  const JournalApp({super.key});

  @override
  _JournalAppState createState() => _JournalAppState();
}

class _JournalAppState extends State<JournalApp> {
  List<Map<String, dynamic>> entries = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _editTitleController = TextEditingController();
  final TextEditingController _editTextController = TextEditingController();
  int _editIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  void _loadEntries() {
    // Load entries from a file or database, if available
    // For this example, we'll use a sample set of entries
    entries = [
      {
        'title': 'Sample Entry 1',
        'text': 'This is the content of the first sample entry.',
        'date': '2023-04-15'
      },
      {
        'title': 'Sample Entry 2',
        'text': 'This is the content of the second sample entry.',
        'date': '2023-04-16'
      },
    ];
    setState(() {});
  }

  void _addEntry() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('What\'s on your mind?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Title',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _textController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Write your entry here...',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _saveEntry(
                  title: _titleController.text.trim(),
                  text: _textController.text.trim(),
                  date: _getCurrentDate(),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _editEntry(int index) {
    _editIndex = index;
    _editTitleController.text = entries[index]['title'];
    _editTextController.text = entries[index]['text'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Entry'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _editTitleController,
                decoration: const InputDecoration(
                  hintText: 'Title',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _editTextController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Write your entry here...',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updateEntry(
                  index: _editIndex,
                  title: _editTitleController.text.trim(),
                  text: _editTextController.text.trim(),
                  date: _getCurrentDate(),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteEntry(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Entry'),
          content: const Text('Are you sure you want to delete this entry?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _removeEntry(index);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _saveEntry({
    required String title,
    required String text,
    required String date,
  }) {
    setState(() {
      entries.add({
        'title': title,
        'text': text,
        'date': date,
      });
    });
  }

  void _updateEntry({
    required int index,
    required String title,
    required String text,
    required String date,
  }) {
    setState(() {
      entries[index] = {
        'title': title,
        'text': text,
        'date': date,
      };
    });
  }

  void _removeEntry(int index) {
    setState(() {
      entries.removeAt(index);
    });
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return '${date.month}/${date.day}/${date.year}';
  }

  String _getCurrentDate() {
    return DateTime.now().toIso8601String().split('T')[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Journal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _addEntry,
              child: const Text('Add an Entry'),
            ),
            const SizedBox(height: 16.0),
            if (entries.isEmpty) const Text('No entries so far.'),
            Expanded(
              child: ListView.builder(
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                entry['title'],
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _formatDate(entry['date']),
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            entry['text'],
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () => _editEntry(index),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF28A745),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 8.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: Text('Edit'),
                              ),
                              const SizedBox(width: 8.0),
                              ElevatedButton(
                                onPressed: () => _deleteEntry(index),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFDC3545),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 8.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
