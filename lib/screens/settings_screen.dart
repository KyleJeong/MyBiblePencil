import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/language_service.dart';
import '../services/font_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageService = context.watch<LanguageService>();
    final fontService = context.watch<FontService>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        children: [
          // Language settings
          ListTile(
            title: Text(l10n.language),
            subtitle: Text(
              languageService.currentLocale.languageCode == 'ko'
                  ? l10n.korean
                  : l10n.english,
            ),
            onTap: () => _showLanguageDialog(context),
          ),
          const Divider(),
          
          // Font family settings
          ListTile(
            title: Text(l10n.font),
            subtitle: Text(fontService.fontFamily),
            onTap: () => _showFontFamilyDialog(context),
          ),
          
          // Font size settings
          ListTile(
            title: Text(l10n.fontSize),
            subtitle: Text(_getFontSizeText(context, fontService.fontSize)),
            onTap: () => _showFontSizeDialog(context),
          ),
        ],
      ),
    );
  }

  String _getFontSizeText(BuildContext context, double size) {
    final l10n = AppLocalizations.of(context)!;
    if (size <= FontService.fontSizePresets['small']!) {
      return l10n.small;
    } else if (size <= FontService.fontSizePresets['medium']!) {
      return l10n.medium;
    } else if (size <= FontService.fontSizePresets['large']!) {
      return l10n.large;
    } else {
      return l10n.extraLarge;
    }
  }

  void _showLanguageDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageService = context.read<LanguageService>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.selectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(l10n.korean),
              onTap: () {
                languageService.setLanguage('ko');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(l10n.english),
              onTap: () {
                languageService.setLanguage('en');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFontFamilyDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final fontService = context.read<FontService>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.selectFont),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: FontService.availableFonts.map((font) => ListTile(
              title: Text(
                font,
                style: TextStyle(fontFamily: font),
              ),
              onTap: () {
                fontService.setFontFamily(font);
                Navigator.pop(context);
              },
            )).toList(),
          ),
        ),
      ),
    );
  }

  void _showFontSizeDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final fontService = context.read<FontService>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.fontSize),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(l10n.small),
              onTap: () {
                fontService.setFontSize(FontService.fontSizePresets['small']!);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(l10n.medium),
              onTap: () {
                fontService.setFontSize(FontService.fontSizePresets['medium']!);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(l10n.large),
              onTap: () {
                fontService.setFontSize(FontService.fontSizePresets['large']!);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(l10n.extraLarge),
              onTap: () {
                fontService.setFontSize(FontService.fontSizePresets['extraLarge']!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
} 