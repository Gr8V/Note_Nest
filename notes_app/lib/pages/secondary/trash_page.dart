import 'package:flutter/material.dart';
import 'package:notes_app/pages/secondary/view_note.dart';
import 'package:notes_app/notes_provider.dart';
import 'package:notes_app/utils.dart';
import 'package:provider/provider.dart';

class TrashPage extends StatefulWidget {
  const TrashPage({super.key});

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {

  Future<void> _emptyBin() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Empty Bin'),
        content: const Text(
            'Are you sure you want to empty Bin? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext, true);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Empty'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!mounted) return;

    final notesProvider = context.read<NotesProvider>();
    await notesProvider.emptyTrash();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Trash Emptied successfully'),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final trashNotes = context.watch<NotesProvider>().trashNotes;
    //theme
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [colorScheme.primary, colorScheme.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Text(
                'Trash',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.3,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.onSurface.withValues(alpha: 0.15),
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.red, Colors.redAccent],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.redAccent,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _emptyBin(),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.delete, color: Colors.white, size: 20),
                ),
              ),
            ),
          ),
        ],
      ),
      body: trashNotes.isEmpty
        ? const Center(child: Text("Bin Is Empty"))
        : ListView.builder(
            itemCount: trashNotes.length,
            itemBuilder: (context, index) {
              final note = trashNotes[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(18),
                  elevation: 2,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {
                      pushWithSlideFade(context, ViewNoteInTrash(note: note));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            note.title.isEmpty ? "Untitled" : note.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                
                          const SizedBox(height: 6),
                
                          // Content preview
                          Text(
                            note.content.isEmpty ? "No content" : note.content,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade700,
                            ),
                          ),
                
                          const SizedBox(height: 12),
                
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              note.date,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );

            },
          ),
    );
  }
}