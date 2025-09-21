import 'package:flutter/material.dart';
import 'package:settings_app/preferences_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  String _language = "es";
  double _fontSize = 16;

  @override
  void initState() {
    super.initState();
    _lodadPreference();
  }

  _lodadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool(PreferencesKey.darkMode) ?? false;
      _language = prefs.getString(PreferencesKey.language) ?? "es";
      _fontSize = prefs.getDouble(PreferencesKey.fontSize) ?? 16;
    });
  }

  _savePreference(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          title: Text("Modo Oscuro"),
          value: _darkMode,
          onChanged: (darkMode) {
            setState(() => _darkMode = darkMode);
            _savePreference(PreferencesKey.darkMode, darkMode);
          },
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 8,
            bottom: 8,
          ),
          child: DropdownButtonFormField(
            value: _language,
            items: [
              DropdownMenuItem(value: "es", child: Text("Español")),
              DropdownMenuItem(value: "en", child: Text("Ingles")),
              DropdownMenuItem(value: "ch", child: Text("Chino")),
            ],
            onChanged: (language) {
              if (language != null) {
                setState(() => _language = language);
                _savePreference(PreferencesKey.language, language);
              }
            },
            decoration: InputDecoration(label: Text("Idiomas")),
          ),
        ),
        Text("Tamaño de la Fuente ${_fontSize.toStringAsFixed(0)}"),
        Slider(
          value: _fontSize,
          min: 14,
          max: 24,
          onChanged: (fontSize) {
            setState(() => _fontSize = fontSize);
            _savePreference(PreferencesKey.fontSize, fontSize);
          },
        ),
      ],
    );
  }
}
