import 'package:flutter/material.dart';

class HomeBottomBar extends StatefulWidget {
  @override
  _HomeBottomBarState createState() => _HomeBottomBarState();
}

class _HomeBottomBarState extends State<HomeBottomBar> {
  int _selectedIndex = 0; // Indice de l'onglet actuellement sélectionné

  // List of bottom navigation bar items with icons and labels
  final List<BottomNavigationBarItem> _items = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      label: 'Home',
      // Add label for the Home icon
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.qr_code),
      label: 'Scann QR', // Add label for the Maps icon
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.chat_outlined),
      label: 'ChatBot', // Add label for the ChatBot icon
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.event_outlined),
      label: 'Events', // Add label for the Events icon
    ),
  ];

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (_selectedIndex) {
      case 0:
        Navigator.popAndPushNamed(context, "/home");
        break;
      case 1:
        Navigator.popAndPushNamed(context, "/qr");
        break;
      case 2:
        Navigator.popAndPushNamed(context, "/chatbot");
        break;
      case 3:
        Navigator.popAndPushNamed(context, "/events");
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      // Use BottomNavigationBar instead of Container
      type: BottomNavigationBarType.fixed, // Fixed type for labels below icons
      currentIndex: _selectedIndex,
      onTap: _onTabChange,
      selectedItemColor: const Color.fromARGB(
          255, 202, 50, 50), // Optional: Set color for selected item
      unselectedItemColor: const Color.fromARGB(
          255, 207, 44, 44), // Optional: Set color for unselected items
      items: _items,
);
}
}
