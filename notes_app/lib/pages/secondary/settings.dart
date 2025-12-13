import 'package:flutter/material.dart';
import 'package:notes_app/pages/secondary/trash_page.dart';
import 'package:notes_app/theme/app_theme.dart';
import 'package:notes_app/theme/colors.dart';
import 'package:notes_app/theme/theme_controller.dart';
import 'package:notes_app/utils.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
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
                'Settings',
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
      ),
      body: Padding(
        padding: EdgeInsets.all(1.0),
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: const Text('Theme'),
              subtitle: const Text('Light, Dark, System'),
              onTap: () {
                pushWithSlideFade(context, ThemeSelectionPage());
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Trash'),
              subtitle: const Text('Restore, Permanently Delete Notes'),
              onTap: () {
                pushWithSlideFade(context, TrashPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ThemeSelectionPage extends StatelessWidget {
  const ThemeSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Theme',
          style: TextStyle(
            color: colorScheme.primary,
            fontWeight: FontWeight.w700,
            fontSize: 22,
            letterSpacing: 1.1,
            fontFamily: 'Poppins',
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.onSurface.withValues(alpha: 0.1),
                colorScheme.surface.withValues(alpha: 0.1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Brightness Mode Section
              Text(
                'Brightness',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 12),
              ValueListenableBuilder<ThemeMode>(
                valueListenable: themeModeNotifier,
                builder: (context, currentMode, child) {
                  return Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        RadioGroup(
                          groupValue: currentMode,
                          onChanged: (value) {
                                  if (value != null) setThemeMode(value);
                                },
                          child: Column(
                            children: [
                              RadioListTile<ThemeMode>(
                                value: ThemeMode.light,
                                title: Row(
                                  children: [
                                    Icon(Icons.light_mode, size: 20),
                                    SizedBox(width: 12),
                                    Text('Light Mode'),
                                  ],
                                ),
                                activeColor: colorScheme.primary,
                              ),
                              Divider(height: 1, color: colorScheme.outline.withValues(alpha: 0.1)),
                              RadioListTile<ThemeMode>(
                                value: ThemeMode.dark,
                                title: const Row(
                                  children: [
                                    Icon(Icons.dark_mode, size: 20),
                                    SizedBox(width: 12),
                                    Text('Dark Mode'),
                                  ],
                                ),
                                activeColor: colorScheme.primary,
                              ),
                              Divider(height: 1, color: colorScheme.outline.withValues(alpha: 0.1)),
                              RadioListTile<ThemeMode>(
                                value: ThemeMode.system,
                                title: const Row(
                                  children: [
                                    Icon(Icons.brightness_auto, size: 20),
                                    SizedBox(width: 12),
                                    Text('System Default'),
                                  ],
                                ),
                                activeColor: colorScheme.primary,
                              ),
                            ],
                          )
                          )
                      ],
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 32),
              
              // Color Theme Section
              Text(
                'Color Theme',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 12),
              
              ValueListenableBuilder<AppThemeType>(
                valueListenable: themeTypeNotifier,
                builder: (context, currentType, child) {
                  return Column(
                    children: [
                      _buildThemeOption(
                        context,
                        type: AppThemeType.defaultTheme,
                        currentType: currentType,
                        title: 'Default',
                        colors: [AppColors.lightPrimary, AppColors.lightSecondary],
                        icon: Icons.auto_awesome,
                      ),
                      const SizedBox(height: 12),
                      _buildThemeOption(
                        context,
                        type: AppThemeType.ocean,
                        currentType: currentType,
                        title: 'Ocean Breeze',
                        colors: [AppColors.oceanLightPrimary, AppColors.oceanLightSecondary],
                        icon: Icons.water,
                      ),
                      const SizedBox(height: 12),
                      _buildThemeOption(
                        context,
                        type: AppThemeType.forest,
                        currentType: currentType,
                        title: 'Forest Green',
                        colors: [AppColors.forestLightPrimary, AppColors.forestLightSecondary],
                        icon: Icons.forest,
                      ),
                      const SizedBox(height: 12),
                      _buildThemeOption(
                        context,
                        type: AppThemeType.sunset,
                        currentType: currentType,
                        title: 'Sunset Glow',
                        colors: [AppColors.sunsetLightPrimary, AppColors.sunsetLightSecondary],
                        icon: Icons.wb_twilight,
                      ),
                      const SizedBox(height: 12),
                      _buildThemeOption(
                        context,
                        type: AppThemeType.lavender,
                        currentType: currentType,
                        title: 'Lavender Dreams',
                        colors: [AppColors.lavenderLightPrimary, AppColors.lavenderLightSecondary],
                        icon: Icons.spa,
                      ),
                      const SizedBox(height: 12),
                      _buildThemeOption(
                        context,
                        type: AppThemeType.mocha,
                        currentType: currentType,
                        title: 'Mocha Warmth',
                        colors: [AppColors.mochaLightPrimary, AppColors.mochaLightSecondary],
                        icon: Icons.coffee,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required AppThemeType type,
    required AppThemeType currentType,
    required String title,
    required List<Color> colors,
    required IconData icon,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = currentType == type;
    
    return GestureDetector(
      onTap: () => setThemeType(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: colors.map((c) => c.withValues(alpha: 0.2)).toList())
              : null,
          color: isSelected ? null : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? colors[0] : colorScheme.outline.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: colors),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: colors),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 20),
              ),
          ],
        ),
      ),
    );
  }
}