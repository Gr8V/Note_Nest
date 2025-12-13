import 'package:flutter/material.dart';
import 'package:notes_app/notes_model.dart';
import 'package:notes_app/notes_provider.dart';
import 'package:provider/provider.dart';

class EditNote extends StatefulWidget {
  final Note note;
  const EditNote({super.key, required this.note});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> with SingleTickerProviderStateMixin{

  late TextEditingController _titleController;
  late TextEditingController _contentController;
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _contentFocus = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isTitleFocused = false;
  bool _isContentFocused = false;
  late bool _isPinned = widget.note.isPinned;


  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
    
    // Add focus listeners
    _titleFocus.addListener(() {
      setState(() {
        _isTitleFocused = _titleFocus.hasFocus;
      });
    });
    
    _contentFocus.addListener(() {
      setState(() {
        _isContentFocused = _contentFocus.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _titleFocus.dispose();
    _contentFocus.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _updateNote() async {
    if (_titleController.text.isEmpty && _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please add a title or content'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    

    final entry = Note(
      id: widget.note.id,
      title: _titleController.text,
      content: _contentController.text,
      date: widget.note.date,
      isPinned: _isPinned
    );
    await notesProvider.updateNote(entry);
    if (!mounted) return;


    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Note updated successfully!'),
        backgroundColor: Colors.green.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    //theme
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [colorScheme.primary, colorScheme.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: const Text(
            'Edit Note',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.3,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        actions: [
          // Pin Icon Button
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: _isPinned 
                  ? colorScheme.primary.withValues(alpha: 0.2)
                  : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isPinned 
                    ? colorScheme.primary 
                    : colorScheme.outline.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  setState(() {
                    _isPinned = !_isPinned;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    _isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                    color: _isPinned ? colorScheme.primary : colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
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
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Input
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _isTitleFocused 
                          ? colorScheme.primary 
                          : colorScheme.outline.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: TextField(
                    controller: _titleController,
                    focusNode: _titleFocus,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Title',
                      hintStyle: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.4),
                        fontWeight: FontWeight.w600,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(20),
                      prefixIcon: Icon(
                        Icons.title,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Content Input
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  constraints: const BoxConstraints(minHeight: 300),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _isContentFocused 
                          ? colorScheme.primary 
                          : colorScheme.outline.withValues(alpha: 0.2),
                      width: 2,
                    ),
                  ),
                  child: TextField(
                    controller: _contentController,
                    focusNode: _contentFocus,
                    maxLines: null,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Start writing your note...',
                      hintStyle: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: _updateNote,
        child: Icon(Icons.save),
      ),
    );
  }
}