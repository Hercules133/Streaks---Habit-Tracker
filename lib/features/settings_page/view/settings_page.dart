import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streaks/core/widgets/app_bar_widget.dart';
import 'package:streaks/core/widgets/drawer_menu_widget.dart';

import 'switch_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final switchState = Provider.of<SwitchState>(context, listen: false);

    return Scaffold(
      appBar: MyAppBar(
        appBar: AppBar(),
        appBarTitle: 'Settings',
      ),
      drawer: const MyDrawerMenu(),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Icon(
                Icons.person_outline,
                size: 55.0,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text("Username"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onSurface,
                      width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.transparent, width: 1),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                hintStyle:
                    TextStyle(color: Theme.of(context).colorScheme.surface),
                hintText: "Type in your name",
                fillColor: Theme.of(context).colorScheme.primary,
              ),
              cursorColor: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text("Languages"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10),
            child: SizedBox(
              width: double.infinity,
              child: DropdownMenuTheme(
                data: DropdownMenuThemeData(
                  menuStyle: MenuStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Set the border radius
                      ),
                    ),
                  ),
                ),
                child: DropdownMenu(
                  initialSelection: 'English',
                  inputDecorationTheme: InputDecorationTheme(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onSurface,
                          width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.transparent, width: 1),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.primary,
                  ),
                  trailingIcon: Icon(
                    Icons.arrow_drop_down,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  width: double.infinity,
                  dropdownMenuEntries: const <DropdownMenuEntry<String>>[
                    DropdownMenuEntry(value: 'English', label: 'English'),
                    DropdownMenuEntry(value: 'Deutsch', label: 'Deutsch'),
                  ],
                ),
              ),
            ),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 10.0, left: 10.0),
              child: Text("Cloud"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onSurface,
                      width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                // Border when the TextField is inactive (not focused)
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.transparent, width: 1),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                hintStyle:
                    TextStyle(color: Theme.of(context).colorScheme.surface),
                hintText: "none",
                fillColor: Theme.of(context).colorScheme.primary,
              ),
              cursorColor: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text("Theme Mode"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
            child: SizedBox(
              width: double.infinity,
              child: DropdownMenuTheme(
                data: DropdownMenuThemeData(
                  menuStyle: MenuStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Set the border radius
                      ),
                    ),
                  ),
                ),
                child: DropdownMenu(
                  inputDecorationTheme: InputDecorationTheme(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onSurface,
                          width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.transparent, width: 1),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.primary,
                  ),
                  width: double.infinity,
                  initialSelection: _getInitialSelection(switchState.themeMode),
                  dropdownMenuEntries: const <DropdownMenuEntry<String>>[
                    DropdownMenuEntry(value: 'dark', label: 'Dark'),
                    DropdownMenuEntry(value: 'light', label: 'Light'),
                    DropdownMenuEntry(value: 'system', label: 'System')
                  ],
                  onSelected: (String? newValue) {
                    if (newValue != null) {
                      switch (newValue) {
                        case 'dark':
                          switchState.toggleThemeMode(ThemeMode.dark);
                          break;
                        case 'light':
                          switchState.toggleThemeMode(ThemeMode.light);
                          break;
                        case 'system':
                          switchState.toggleThemeMode(ThemeMode.system);
                          break;
                      }
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _getInitialSelection(ThemeMode themeMode) {
  switch (themeMode) {
    case ThemeMode.dark:
      return 'dark';
    case ThemeMode.light:
      return 'light';
    case ThemeMode.system:
      return 'system';
  }
}
