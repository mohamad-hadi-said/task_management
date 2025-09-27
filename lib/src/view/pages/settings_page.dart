import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  String selectedLanguage = "العربية";
  String selectedTheme = "داكن";

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        /// قسم عام
        _buildSectionTitle("عام"),
        ListTile(
          title: const Text(
            "لغة التطبيق",
            style: TextStyle(color: Colors.white),
          ),
          trailing: Text(
            selectedLanguage,
            style: TextStyle(color: Colors.grey[400]),
          ),
          onTap: () {
            _showLanguageDialog();
          },
        ),

        const SizedBox(height: 16),

        /// قسم التفضيلات
        _buildSectionTitle("التفضيلات"),
        SwitchListTile(
          activeColor: Colors.blue,
          title: const Text(
            "التحكم في الإشعارات",
            style: TextStyle(color: Colors.white),
          ),
          value: notificationsEnabled,
          onChanged: (value) {
            setState(() {
              notificationsEnabled = value;
            });
          },
        ),

        const SizedBox(height: 16),

        /// قسم الثيم
        _buildSectionTitle("ثيم"),
        ListTile(
          title: Text(selectedTheme, style: TextStyle(color: Colors.grey[400])),
          trailing: const Icon(Icons.arrow_back_ios, color: Colors.grey),
          onTap: () {
            _showThemeDialog();
          },
        ),
      ],
    );
  }

  /// widget عنوان القسم
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey[400],
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// حوار اختيار اللغة
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: const Text(
            "اختر اللغة",
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [_languageOption("العربية"), _languageOption("English")],
          ),
        );
      },
    );
  }

  Widget _languageOption(String lang) {
    return RadioListTile(
      activeColor: Colors.blue,
      value: lang,
      groupValue: selectedLanguage,
      onChanged: (value) {
        setState(() {
          selectedLanguage = value.toString();
        });
        Navigator.pop(context);
      },
      title: Text(lang, style: const TextStyle(color: Colors.white)),
    );
  }

  /// حوار اختيار الثيم
  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: const Text(
            "اختر الثيم",
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [_themeOption("داكن"), _themeOption("فاتح")],
          ),
        );
      },
    );
  }

  Widget _themeOption(String theme) {
    return RadioListTile(
      activeColor: Colors.blue,
      value: theme,
      groupValue: selectedTheme,
      onChanged: (value) {
        setState(() {
          selectedTheme = value.toString();
        });
        Navigator.pop(context);
      },
      title: Text(theme, style: const TextStyle(color: Colors.white)),
    );
  }
}
