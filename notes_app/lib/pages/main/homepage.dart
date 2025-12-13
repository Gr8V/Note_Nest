import 'package:flutter/material.dart';
import 'package:notes_app/pages/secondary/add_note.dart';
import 'package:notes_app/pages/secondary/search_page.dart';
import 'package:notes_app/pages/secondary/settings.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildNotesList(notes, colorScheme),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            pushWithSlideFade(context, ViewNote(note: note));
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title row with pin
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        note.title.isEmpty ? "Untitled" : note.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    if (note.isPinned)
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.push_pin,
                          size: 14,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 10),

                // Content preview
                Text(
                  note.content.isEmpty ? "No content" : note.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                  ),
                ),

                const SizedBox(height: 12),

                // Date with icon
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 12,
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      note.date,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}