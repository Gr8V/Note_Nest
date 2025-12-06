import 'package:flutter/material.dart';
import 'package:notes_app/pages/secondary/add_note.dart';
import 'package:notes_app/pages/secondary/folders_page.dart';
import 'package:notes_app/pages/secondary/search_page.dart';
import 'package:notes_app/pages/secondary/settings.dart';
import 'package:notes_app/pages/secondary/trash_page.dart';
import 'package:notes_app/pages/secondary/view_note.dart';
import 'package:notes_app/providers/notes_provider.dart';
import 'package:notes_app/utils.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Sorting options
  String _sortBy = 'date'; // 'date', 'title'
  bool _isAscending = false; // true = ascending, false = descending
  @override
  Widget build(BuildContext context) {
    final notes = context.watch<NotesProvider>().notes;
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
                'Notes',
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
          IconButton(
            icon: Icon(Icons.search, color: colorScheme.primary),
            onPressed: () {
              pushWithSlideFade(context, SearchPage());
            },
          ),
          // Sort Button
          PopupMenuButton<String>(
            icon: Icon(Icons.sort, color: colorScheme.primary),
            onSelected: (value) {
              setState(() {
                if (value == 'date' || value == 'title') {
                  _sortBy = value;
                } else if (value == 'ascending' || value == 'descending') {
                  _isAscending = value == 'ascending';
                }
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'date',
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: _sortBy == 'date' ? colorScheme.primary : null,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Sort by Date',
                      style: TextStyle(
                        fontWeight: _sortBy == 'date' ? FontWeight.bold : FontWeight.normal,
                        color: _sortBy == 'date' ? colorScheme.primary : null,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'title',
                child: Row(
                  children: [
                    Icon(
                      Icons.title,
                      size: 18,
                      color: _sortBy == 'title' ? colorScheme.primary : null,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Sort by Title',
                      style: TextStyle(
                        fontWeight: _sortBy == 'title' ? FontWeight.bold : FontWeight.normal,
                        color: _sortBy == 'title' ? colorScheme.primary : null,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'ascending',
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      size: 18,
                      color: _isAscending ? colorScheme.primary : null,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Ascending',
                      style: TextStyle(
                        fontWeight: _isAscending ? FontWeight.bold : FontWeight.normal,
                        color: _isAscending ? colorScheme.primary : null,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'descending',
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_downward,
                      size: 18,
                      color: !_isAscending ? colorScheme.primary : null,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Descending',
                      style: TextStyle(
                        fontWeight: !_isAscending ? FontWeight.bold : FontWeight.normal,
                        color: !_isAscending ? colorScheme.primary : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.settings, color: colorScheme.primary),
            onPressed: () {
              pushWithSlideFade(context, Settings());
            },
          ),
        ],
      ),
      body: _buildNotesList(notes, colorScheme),
      drawer: Drawer(
        backgroundColor: colorScheme.surface,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // 🔥 HEADER
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary.withValues(alpha: 0.25),
                      colorScheme.secondary.withValues(alpha: 0.25),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: colorScheme.primary.withValues(alpha: 0.2),
                      child: Icon(
                        Icons.person,
                        color: colorScheme.primary,
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "My Notes",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Organize everything",
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 🔥 MENU OPTIONS
              _drawerTile(
                icon: Icons.folder,
                label: "Folders",
                colorScheme: colorScheme,
                onTap: () {
                  pushWithSlideFade(context, FoldersPage());
                },
              ),

              _drawerTile(
                icon: Icons.delete_outline,
                label: "Trash",
                colorScheme: colorScheme,
                onTap: () {
                  pushWithSlideFade(context, TrashPage());
                },
              ),

              const Spacer(),

              // 🔥 FOOTER
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Text(
                    "Notes App v1.0",
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.4),
                      fontSize: 12,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          pushWithSlideFade(context, AddNote());
        },
        child: Icon(Icons.add),
      ),
    );
  }
   // 📝 Notes List Builder
  Widget _buildNotesList(List notes, ColorScheme colorScheme) {
    if (notes.isEmpty) {
      return const Center(child: Text("No notes"));
    }

    // Sort notes
    final sortedNotes = List.from(notes);
    
    sortedNotes.sort((a, b) {
      // First priority: pinned notes always at top
      if (a.isPinned != b.isPinned) {
        return a.isPinned ? -1 : 1;
      }
      
      // Second priority: sort by selected criteria
      int comparison = 0;
      
      if (_sortBy == 'date') {
        comparison = a.date.compareTo(b.date);
      } else if (_sortBy == 'title') {
        comparison = a.title.toLowerCase().compareTo(b.title.toLowerCase());
      }
      
      // Apply ascending/descending
      return _isAscending ? comparison : -comparison;
    });

    return ListView.builder(
      itemCount: sortedNotes.length,
      itemBuilder: (context, index) {
        final note = sortedNotes[index];
        return _buildNoteCard(note, colorScheme);
      },
    );
  }

  // 🎴 Individual Note Card
  Widget _buildNoteCard(dynamic note, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        elevation: 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            pushWithSlideFade(context, ViewNote(note: note));
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: note.isPinned 
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  )
                : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title with pin icon
                Row(
                  children: [
                    if (note.isPinned)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.push_pin,
                          size: 16,
                          color: colorScheme.primary,
                        ),
                      ),
                    Expanded(
                      child: Text(
                        note.title.isEmpty ? "Untitled" : note.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
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
                // Date
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
  }
}

Widget _drawerTile({
  required IconData icon,
  required String label,
  required ColorScheme colorScheme,
  required VoidCallback onTap,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    child: Material(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: Row(
            children: [
              Icon(icon, color: colorScheme.primary, size: 24),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
